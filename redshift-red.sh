#!/bin/bash

# Reset redshift to normal
redshift -x

# Set color temperature to 3900K (run twice as specified)
redshift -O 3900
redshift -O 5300
