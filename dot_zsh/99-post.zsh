#!/usr/bin/env zsh

##############################################################################
# Finalization and Cleanup
##############################################################################

# Refresh command hash table
hash -r 2>/dev/null || command rehash 2>/dev/null
