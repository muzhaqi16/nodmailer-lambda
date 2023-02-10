"use strict";

const nodemailer = require("nodemailer");
const aws = require("@aws-sdk/client-ses");
const { defaultProvider } = require("@aws-sdk/credential-provider-node");

module.exports.handler = async (event) => {
  const ses = new aws.SES({
    apiVersion: "2010-12-01",
    region: "us-east-1",
    defaultProvider,
  });

  // create Nodemailer SES transporter
  let transporter = nodemailer.createTransport({
    SES: { ses, aws },
    sendingRate: 1, // max 1 messages/second
  });

  // Push next messages to Nodemailer
  transporter.once("idle", () => {
    if (transporter.isIdle()) {
      transporter.sendMail(
        {
          from: "contact@pantrytrak.app",
          to: "artanmuzhaqi@gmail.com",

          subject: "Message ✓ " + Date.now(),
          text: "I hope this message gets sent! ✓",
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
        (err, info) => {
          console.log(err, info);
        }
      );
    }
  });
};
