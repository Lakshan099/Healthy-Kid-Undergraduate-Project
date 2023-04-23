

import { initializeApp } from "https://www.gstatic.com/firebasejs/9.14.0/firebase-app.js";
import { getFirestore, setDoc, addDoc, doc, collection } from "https://www.gstatic.com/firebasejs/9.14.0/firebase-firestore.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.14.0/firebase-analytics.js";


// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyBO4PtPQwFT-A09h1BaNDGb6homZDIL-oU",
    authDomain: "healthy-kid-8a121.firebaseapp.com",
    databaseURL: "https://healthy-kid-8a121-default-rtdb.firebaseio.com",
    projectId: "healthy-kid-8a121",
    storageBucket: "healthy-kid-8a121.appspot.com",
    messagingSenderId: "1075043222463",
    appId: "1:1075043222463:web:4639b2ea7c98bf3ad8970a",
    measurementId: "G-0VBYLVWZH9"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
// Initialize Cloud Firestore and get a reference to the service
const db = getFirestore(app);
const analytics = getAnalytics(app);



submitData.addEventListener('click', (e) => {
    var name = document.getElementById('name').value;
    var email = document.getElementById('email').value;
    var subject = document.getElementById('subject').value;
    var msg = document.getElementById('message').value;

    setDoc(doc(db, "Contact", email), {
        Name: name,
        Email: email,
        Subject: subject,
        ReplyMsg: msg
    });
});


