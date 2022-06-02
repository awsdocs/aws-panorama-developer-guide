# Running multiple threads<a name="applications-threading"></a>

You can run your application logic on a processing thread and use other threads for other background processes\. For example, you can create a thread that [serves HTTP traffic](applications-ports.md) for debugging, or a thread that monitors inference results and sends data to AWS\.

To run multiple threads, you use the [threading module](https://docs.python.org/3/library/threading.html) from the Python standard library to create a thread for each process\. The following example shows the main loop of the debug server sample application, which creates an application object and uses it to run 3 threads\.

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

When all of the threads exit, the application restarts itself\. The `run_cv` loop processes images from camera streams\. If it receives a signal to stop, it shuts down the debugger process, which runs an HTTP server and can't shut itself down\. Each thread must handle its own errors\. If an error is not caught and logged, the thread exits silently\.

**Example [packages/123456789012\-DEBUG\_SERVER\-1\.0/application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/packages/123456789012-DEBUG_SERVER-1.0/application.py) – Processing loop**  

```
    # Processing loop
    def run_cv(self):
        """Run computer vision workflow in a loop."""
        logger.info("PROCESSING STREAMS")
        while not self.terminate:
            try:
                self.process_streams()
                # turn off debug logging after 15 loops
                if logger.getEffectiveLevel() == logging.DEBUG and self.frame_num == 15:
                    logger.setLevel(logging.INFO)
            except:
                logger.exception('Exception on processing thread.')
        # Stop signal received
        logger.info("SHUTTING DOWN SERVER")
        self.server.shutdown()
        self.server.server_close()
        logger.info("EXITING RUN THREAD")
```

Threads communicate via the application's `self` object\. To shut down the application and trigger a restart, the debugger thread calls the `stop` method\. This method sets a `terminate` attribute, which signals the other threads to shut down\.

**Example [packages/123456789012\-DEBUG\_SERVER\-1\.0/application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server/packages/123456789012-DEBUG_SERVER-1.0/application.py) – Stop method**  

```
    # Interrupt processing loop
    def stop(self):
        """Signal application to stop processing."""
        logger.info("STOPPING APPLICATION")
        # Signal processes to stop
        self.terminate = True
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
                if self.path == "/status":
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
```

