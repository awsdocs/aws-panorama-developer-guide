# Serving inbound traffic<a name="applications-ports"></a>

You can monitor or debug applications locally by running an HTTP server alongside your application code\. To serve external traffic, you map ports on the AWS Panorama Appliance to ports on your application container\.

**Important**  
By default, the AWS Panorama Appliance does not accept incoming traffic on any ports\. Opening ports on the appliance has implicit security risk\. When you use this feature, you must take additional steps to [secure your appliance from external traffic](appliance-network.md) and secure communications between authorized clients and the appliance\.  
The sample code included with this guide is for demonstration purposes and does not implement authentication, authorization, or encryption\.

You can open up ports in the range 8000\-9000 on the appliance\. These ports, when opened, can receive traffic from any routable client\. When you deploy your application, you specify which ports to open, and map ports on the appliance to ports on your application container\. The appliance software forwards traffic to the container, and sends responses back to the requestor\. Requests are received on the appliance port you specify and responses go out on a random ephemeral port\.

## Configuring inbound ports<a name="applications-ports-configuration"></a>

You specify port mappings in 3 places in your application configuration\. The code package's `package.json`, you specify the port that the code node listens on in a `network` block\. The following example declares that the node listens on port 80\.

**Example [packages/123456789012\-DEBUG\_SERVER\-1\.0/package\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/packages/123456789012-DEBUG_SERVER-1.0/package.json)**  

```
                "outputs": [
                    {
                        "description": "Video stream output",
                        "name": "video_out",
                        "type": "media"
                    }
                ],
                "network": {
                    "inboundPorts": [
                        {
                            "port": 80,
                            "description": "http"
                        }
                    ]
                }
```

In the application manifest, you declare a routing rule that maps a port on the appliance to a port on the application's code container\. The following example adds a rule that maps port 8080 on the device to port 80 on the `code_node` container\.

**Example [graphs/my\-app/graph\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/graphs/my-app/graph.json)**  

```
            {
                "producer": "model_input_width",
                "consumer": "code_node.model_input_width"
            },
            {
                "producer": "model_input_order",
                "consumer": "code_node.model_input_order"
            }
        ],
        "networkRoutingRules": [
            {
                "node": "code_node",
                "containerPort": 80,
                "hostPort": 8080,
                "decorator": {
                    "title": "Listener port 8080",
                    "description": "Container monitoring and debug."
                }
            }
        ]
```

When you deploy the application, you specify the same rules in the AWS Panorama console, or with an override document passed to the [CreateApplicationInstance](https://docs.aws.amazon.com/panorama/latest/api/API_CreateApplicationInstance.html) API\. You must provide this configuration at deploy time to confirm that you want to open ports on the appliance\.

**Example [graphs/my\-app/override\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/graphs/my-app/override.json)**  

```
            {
                "replace": "camera_node",
                "with": [
                    {
                        "name": "exterior-north"
                    }
                ]
            }
        ],
        "networkRoutingRules":[
            {
                "node": "code_node",
                "containerPort": 80,
                "hostPort": 8080
            }
        ],
        "envelopeVersion": "2021-01-01"
    }
}
```

If the device port specified in the application manifest is in use by another application, you can use the override document to choose a different port\.

## Serving traffic<a name="applications-ports-serverthread"></a>

With ports open on the container, you can open a socket or run a server to handle incoming requests\. The `debug-server` sample shows a basic implementation of an HTTP server running alongside computer vision application code\.

**Important**  
The sample implementation is not secure for production use\. To avoid making your appliance vulnerable to attacks, you must implement appropriate security controls in your code and network configuration\.

**Example [packages/123456789012\-DEBUG\_SERVER\-1\.0/application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/packages/123456789012-DEBUG_SERVER-1.0/application.py) – HTTP server**  

```
    # HTTP debug server
    def run_debugger(self):
        """Process debug commands from local network."""
        class ServerHandler(SimpleHTTPRequestHandler):
            # Store reference to application
            application = self
            # Get status
            def do_GET(self):
                """Process GET requests."""
                logger.info('Get request to {}'.format(self.path))
                if self.path == '/status':
                    self.send_200('OK')
                else:
                    self.send_error(400)
            # Restart application
            def do_POST(self):
                """Process POST requests."""
                logger.info('Post request to {}'.format(self.path))
                if self.path == '/restart':
                    self.send_200('OK')
                    ServerHandler.application.stop()
                else:
                    self.send_error(400)
            # Send response
            def send_200(self, msg):
                """Send 200 (success) response with message."""
                self.send_response(200)
                self.send_header('Content-Type', 'text/plain')
                self.end_headers()
                self.wfile.write(msg.encode('utf-8'))
        try:
            # Run HTTP server
            self.server = HTTPServer(("", self.CONTAINER_PORT), ServerHandler)
            self.server.serve_forever(1)
            # Server shut down by run_cv loop
            logger.info("EXITING SERVER THREAD")
        except:
            logger.exception('Exception on server thread.')
```

The server accepts GET requests at the `/status` path to retrieve some information about the application\. It also accepts a POST request to `/restart` to restart the application\.

To demonstrate this functionality, the sample application runs an HTTP client on a separate thread\. The client calls the `/status` path over the local network shortly after startup, and restarts the application a few minutes later\.

**Example [packages/123456789012\-DEBUG\_SERVER\-1\.0/application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/packages/123456789012-DEBUG_SERVER-1.0/application.py) – HTTP client**  

```
    # HTTP test client
    def run_client(self):
        """Send HTTP requests to device port to demnostrate debug server functions."""
        def client_get():
            """Get container status"""
            r = requests.get('http://{}:{}/status'.format(self.device_ip, self.DEVICE_PORT))
            logger.info('Response: {}'.format(r.text))
            return
        def client_post():
            """Restart application"""
            r = requests.post('http://{}:{}/restart'.format(self.device_ip, self.DEVICE_PORT))
            logger.info('Response: {}'.format(r.text))
            return
        # Call debug server
        while not self.terminate:
            try:
                time.sleep(30)
                client_get()
                time.sleep(300)
                client_post()
            except:
                logger.exception('Exception on client thread.')
        # stop signal received
        logger.info("EXITING CLIENT THREAD")
```

The main loop manages the threads and restarts the application when they exit\.

**Example [packages/123456789012\-DEBUG\_SERVER\-1\.0/application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/packages/123456789012-DEBUG_SERVER-1.0/application.py) – Main loop**  

```
def main():
    panorama = panoramasdk.node()
    while True:
        try:
            # Instantiate application
            logger.info('INITIALIZING APPLICATION')
            app = Application(panorama)
            # Create threads for stream processing, debugger, and client
            app.run_thread = threading.Thread(target=app.run_cv)
            app.server_thread = threading.Thread(target=app.run_debugger)
            app.client_thread = threading.Thread(target=app.run_client)
            # Start threads
            logger.info('RUNNING APPLICATION')
            app.run_thread.start()
            logger.info('RUNNING SERVER')
            app.server_thread.start()
            logger.info('RUNNING CLIENT')
            app.client_thread.start()
            # Wait for threads to exit
            app.run_thread.join()
            app.server_thread.join()
            app.client_thread.join()
            logger.info('RESTARTING APPLICATION')
        except:
            logger.exception('Exception during processing loop.')
```

To deploy the sample application, see the [instructions in this guide's GitHub repository\.](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/README.md)