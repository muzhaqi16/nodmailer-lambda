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

  transporter.verify(function (error, success) {
    if (error) {
      console.log(error);
    } else {
      console.log("Server is ready to take our messages");
    }
  });
  // Push next messages to Nodemailer
  transporter.once("idle", async () => {
    if (transporter.isIdle()) {
      return transporter.sendMail(
        {
          from: "contact@pantrytrak.app",
          to: "artanmuzhaqi@gmail.com",

          subject: "Message ✓ " + Date.now(),
          text: "I hope this message gets sent! ✓",
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
    }
  });
};
