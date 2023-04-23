const email = document.getElementById('email');
const submit = document.getElementsByClassName('form-contact')[0];

submit.addEventListener('submit', (e)=>{
    e.preventDefault();
    console.log("Clicked");

    Email.send({
        SecureToken: "5d9e97a1-47a2-4c62-8011-d52e8e952d9f",
        To: "healthykid2023@gmail.com",
        From: "healthykid2023@gmail.com",
        Subject: "1111111111",
        Body: "11111111111"
    }).then(
        message => alert(message)
    );

});