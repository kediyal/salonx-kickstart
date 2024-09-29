# salonx-kickstart

The script I wrote to quickly get the Django backend running on the cloud as part of my internship at Lagaland LLP.

## Additional Configurations

While this script focuses on the rapid deployment of the Django backend, several essential configurations were also implemented outside the scope of this script:

- **Nginx Configuration**: Set up to serve static files and proxy requests to the Gunicorn application server.
- **Gunicorn Configuration**: Configured to efficiently manage application processes for optimal performance.
- **File Permissions for Static Files**: Adjusted permissions to ensure proper access and security for static files.

These configurations are crucial for a robust production environment and should be considered when deploying the backend. Maybe I will combine all those steps into one script in the future, but for now, this is good enough. 