#!/bin/bash

# Start SSH
service ssh start

# Start Laravel
php artisan serve --host=0.0.0.0 --port=8000
