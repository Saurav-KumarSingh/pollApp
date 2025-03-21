const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRoutes = require('./routes/auth');
const pollRoutes = require('./routes/poll');
const cookieParser=require('cookie-parser');
// require('dotenv').config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({extended:true}))
app.use(cookieParser());
app.use(cors());

app.use('/auth', authRoutes);
app.use('/poll', pollRoutes);

mongoose.connect('mongodb://localhost:27017/poll-app')
  .then(() => app.listen(5000, () => console.log('Server running on port 5000')))
  .catch(error => console.log(error));
