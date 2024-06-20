// functions/index.js

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNewsNotification = functions.firestore
    .document("news/{newsId}")
    .onCreate(async (snap, context) => {
      const newsData = snap.data();

      const message = {
        notification: {
          title: "New News Posted",
          body: newsData.title,
        },
        topic: "news_updates",
      };

      try {
        await admin.messaging().send(message);
        console.log("Notification sent successfully");
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });
