"use strict";

import nodemailer from "nodemailer";

/* --- Select AWS SDK version by uncommenting correct version --- */

import aws, { SES } from "@aws-sdk/client-ses";
import { getDefaultRoleAssumerWithWebIdentity } from "@aws-sdk/client-sts";
import { defaultProvider } from "@aws-sdk/credential-provider-node";
/* --- Change these values to test --- */

const provider = defaultProvider({
  roleAssumerWithWebIdentity: getDefaultRoleAssumerWithWebIdentity(),
});

const FROM_ADDRESS = process.env.FROM_ADDRESS;

// configure SES client with credentials from environment variables
const ses = new SES({
  apiVersion: "2010-12-01",
  region: "us-east-1",
  defaultProvider: provider,
});

// create Nodemailer SES transporter
let transporter = nodemailer.createTransport({
  SES: { ses, aws },
  sendingRate: 1, // max 1 messages/second
  logger: process.env.ENV === "dev" ? true : false, // log to console
  debug: process.env.ENV === "dev" ? true : false, // include SMTP traffic in the logs
});

try {
  await transporter.verify();
  console.log("Credentials are valid. Server is ready to take our messages");
} catch (err) {
  // throws on invalid credentials
  console.log("Credentials are invalid. Unable to send messages");
  throw err;
}

export const handler = async (event) => {
  /* --- no need to change below this line when testing --- */
  const { code, email } = event;
  if (!code || !email) {
    throw new Error("Missing code or email");
  }
  const TO_ADDRESS = email;

  const result = await transporter.sendMail({
    from: FROM_ADDRESS,
    to: TO_ADDRESS,

    subject: "Verification code ",
    text: "Your verification code is " + code,
    ses: {
      // optional extra arguments for SendRawEmail
      Tags: [
        {
          Name: "tag_name",
          Value: "tag_value",
        },
      ],
    },
  });

  return result;
};
