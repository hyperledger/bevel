#!/bin/bash

xterm -title "Docker Pool Setup" -hold -e "./pool-setup.sh" &
xterm -title "Indy Pool Transactions" -hold -e "./pool-transaction.sh"
