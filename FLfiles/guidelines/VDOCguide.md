# Description
> This file contains the guidelines for the VDAOMs for the VDAOC Operations.

# Guidelines
1. To make a `Join Proposal` for a `_candidate`, $VDAOM_p$ must submit transaction `function proposeJoin(address _candidate)`.
2. To vote on a `Join Proposal` for a `_candidate`, $VDAOM_i$ must submit transaction `function voteJoin(address _candidate, bool _vote)`, where `_vote=true` indicates approval and `_vote=false` indicate disapproval for `Join Proposal`.
3. To make a `Kick Proposal` for a `_candidate`, $VDAOM_p$ must submit transaction `function proposeKick(address _candidate)`.
4. To vote on a `Kick Proposal` for a `_candidate`, $VDAOM_i$ must submit transaction `function voteKick(address _candidate, bool _vote)`, where `_vote=true` indicates approval and `_vote=false` indicate disapproval for `Kick Proposal`.