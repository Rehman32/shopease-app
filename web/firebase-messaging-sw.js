// web/firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js');

// Replace with your Firebase config
firebase.initializeApp({
 apiKey: "AIzaSyA6vMcdzY95WNwsXMl1chR-qBTyVymqZqg",
 authDomain: "fitconnect-58633.firebaseapp.com",
 projectId: "fitconnect-58633",
 storageBucket: "fitconnect-58633.appspot.com",
 messagingSenderId: "421408284826",
 appId: "1:421408284826:android:66e49892de979077cf3f23"
});

const messaging = firebase.messaging();