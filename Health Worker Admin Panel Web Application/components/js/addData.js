let btnAdd = document.querySelector('button');
let table = document.querySelector('table');


let CnameInput = document.querySelector('#Cname');
let locationInput = document.querySelector('#location');
let descriptionInput = document.querySelector('#description');
let dateInput = document.querySelector('#date');
let timeInput = document.querySelector('#time');



btnAdd.addEventListener('click', () => {
    let Cname = CnameInput.value;
    let location = locationInput.value;
    let description = descriptionInput.value;
    let date = dateInput.value;
    let time = timeInput.value;

    let template = `
                <tr>
                    <td>${Cname}</td>
                    <td>${location}</td>
                    <td>${description}</td>
                    <td>${date}</td>
                    <td>${time}</td>                   
                </tr>`;

    table.innerHTML += template;
});