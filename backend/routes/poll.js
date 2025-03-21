const express = require('express');
const router = express.Router();
const Poll = require('../models/poll'); // Import the Poll model
const jwt = require('jsonwebtoken'); // Import jwt for verifying tokens



// Create a new poll (requires authentication)
router.post('/create/:id', async (req, res) => {
  try {
    const poll = new Poll({
      ...req.body,
      createdBy: req.params.id,
    });
    
    await poll.save();
    res.status(201).json(poll);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Get all polls
router.get('/', async (req, res) => {
  try {
    const polls = await Poll.find().populate('createdBy', 'username'); // Assuming you have a User model
    res.json(polls);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get a single poll by ID
router.get('/:id', async (req, res) => {
  try {
    const poll = await Poll.findById(req.params.id).populate('createdBy', 'username');
    if (!poll) return res.status(404).json({ message: 'Poll not found' });
    res.json(poll);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Voting on a poll using option index
router.put('/vote/:pollId', async (req, res) => {
  const { optionIndex } = req.body; 
  console.log(req.params)
  try {
    const poll = await Poll.findById(req.params.pollId);
    if (!poll) {
      return res.status(404).json({ message: 'Poll not found' });
    }

    // Check if the optionIndex is valid
    if (optionIndex < 0 || optionIndex >= poll.options.length) {
      return res.status(400).json({ message: 'Invalid option index' });
    }

    // Increment the vote count for the option at the given index
    poll.options[optionIndex].votes += 1;

    // Save the updated poll
    await poll.save();
    res.status(200).json({ message: 'Vote cast successfully', poll });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
