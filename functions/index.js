const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const fcm = admin.messaging();

exports.myMessages = functions.firestore
  .document(`Chats/{chat}/ChatRoom/{message}`)
  .onCreate((snapshot, context) => {
    fcm.sendToDevice(snapshot.data().chattingWith, {
      notification: {
        title: `Message from ${snapshot.data().sentFrom}`,
        body: snapshot.data().text,
        icon: "drawable/ic_stat_logo2",
        sound: "default",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });

    return;
  });

exports.myChatsRequested = functions.firestore
  .document("Chats/{chat}")
  .onUpdate((change, context) => {
    fcm.sendToTopic("Chat", {
      notification: {
        title: `Chat request!`,
        body: `${
          change.after.data().requestedUser
        } wants some help! Go start a new chat.`,
        icon: "drawable/ic_stat_logo2",
        sound: "default",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });

exports.myOrders = functions.firestore
  .document("Admin/Store/Orders/{order}")
  .onCreate((snapshot, context) => {
    fcm.sendToTopic("Orders", {
      notification: {
        title: `A New order!`,
        body: `${snapshot.data().userEmail} just placed a new order!`,
        icon: "drawable/ic_stat_logo2",
        sound: "default",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });

exports.myOrderUpdates = functions.firestore
  .document("Admin/Store/Orders/{order}")
  .onUpdate((change, context) => {
    fcm.sendToDevice(change.after.data().deviceToken, {
      notification: {
        title: `Here's an Update for you!`,
        body: `Your order ${change.after.data().id} is now ${
          change.after.data().orderStatus
        }`,
        icon: "drawable/ic_stat_logo2",
        sound: "default",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });
