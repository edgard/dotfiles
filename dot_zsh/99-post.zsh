# Post-load configuration
# Final tweaks and cleanup after all other configurations are loaded

# Remove duplicate PATH entries
typeset -U path

# Clear any unused hash table entries
hash -r
