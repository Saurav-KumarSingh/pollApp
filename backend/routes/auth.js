const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/user');
const cookieParser = require('cookie-parser');

const router = express.Router();

// Middleware to use cookie-parser
router.use(cookieParser());

// Signup route
router.post('/signup', async (req, res) => {
  const { username, email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({ username, email, password: hashedPassword });
    await newUser.save();
    res.status(200).json({ message: 'User created successfully',success:true });
  } catch (error) {
    res.status(400).json({ error: 'User creation failed',success:false });
  }
});

// Login route with cookie
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  
  try {
    const user = await User.findOne({ email });
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    // Generate JWT token
    const token = jwt.sign({ userId: user._id }, 'pollll', { expiresIn: '1h' });

    // Store the token in a cookie
    res.cookie('authToken', token, {
      // httpOnly: true, 
      maxAge: 60 * 60 * 1000 // 1 hour in milliseconds
    });

    res.status(200).json({ message: 'Login successful',success:true,name:user.username,email:user.email,id:user._id });
  } catch (error) {
    res.status(500).json({ error: 'Login failed',success:false });
  }
});

// Logout route to clear the cookie
router.post('/logout', (req, res) => {
  res.clearCookie('authToken');
  res.status(200).json({ message: 'Logout successful',success:true });
});

module.exports = router;
