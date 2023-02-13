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

export const handler = async (event) => {
  /* --- no need to change below this line when testing --- */
  const { code, email } = event;
  if (!code || !email) {
    throw new Error("Missing code or email");
  }
  const TO_ADDRESS = email;
  const ses = new SES({
    apiVersion: "2010-12-01",
    region: "us-east-1",
    defaultProvider: provider,
  });

  // create Nodemailer SES transporter
  let transporter = nodemailer.createTransport({
    SES: { ses, aws },
    sendingRate: 1, // max 1 messages/second
  });

  const response = await new Promise((resolve, reject) => {
    transporter.verify(function (error, success) {
      if (error) {
        reject(error);
      }
      if (success) {
        resolve("Server is ready to take our messages");
      }
    });
  });
  console.log(response);

  const info = await new Promise((resolve, reject) => {
    transporter.once("idle", async () => {
      return transporter.sendMail(
        {
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
        },
        (error, info) => {
          if (error) {
            console.log("Error occurred");
            console.log(error.message);
            return process.exit(1);
          }

          console.log("Message sent successfully!");
          console.log(nodemailer.getTestMessageUrl(info));

          // only needed when using pooled connections
          transporter.close();
        }
      );
    });
  });
  return info;
};
