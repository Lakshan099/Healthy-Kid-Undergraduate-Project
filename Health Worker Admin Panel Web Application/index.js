const express = require("express");
const PORT = process.env.PORT || 3000;
const bodyParser = require('body-parser');

const loginRouter = require('./routes/loginRoute');
const signupRouter = require('./routes/signupRoute');
const signoutRouter = require('./routes/signoutRoute');
const dashbordRouter = require('./routes/dashbordRoute');
const userRouter = require('./routes/usersRoute');
const contactRouter = require('./routes/contactRoute');
const clinicsRouter = require('./routes/clinicsRoute');
const healthReportRouter1 = require('./routes/healthReportRoute');

const app = express();


app.use(express.static('pages'));
app.use(express.static('components'));

app.use(bodyParser.urlencoded({ extended: false }));

app.use(loginRouter);
app.use('/signup', signupRouter);
app.use('/signout', signoutRouter);
app.use('/dashbord', dashbordRouter);
app.use('/user', userRouter);
app.use('/contact', contactRouter);
app.use('/clinic', clinicsRouter);
app.use('/report', healthReportRouter1);

app.listen(PORT, () => {
    console.log(`Server is running at PORT ${PORT}`);
})
