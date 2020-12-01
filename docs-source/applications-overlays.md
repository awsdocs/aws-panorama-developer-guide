# Adding text and boxes to output video<a name="applications-overlays"></a>

With the AWS Panorama SDK, you can output a video stream to a display\. The video can include text and boxes that show output from model, the current state of the application, or other data\.

Each object in the `video_in` array is an image from a camera stream that is connected to the appliance\. The type of this object is `panoramasdk.media`\. It has methods to add text and rectangular boxes onto the image, which you can then assign to the `video_out` array\.

In the following example, the sample application overlays the number of people in frame, and draws a box around each\. It gets the coordinates of the box from the model, which outputs the location of each result, in addition to the class and confidence\.

**Example lambda\_function\.py – Bounding boxes and text**  

```
    def entry(self, inputs, outputs):
        for i in range(len(inputs.video_in)):
            stream = inputs.video_in[i]
            person_image = stream.image
            ...
            # Draw bounding boxes on output image
            if self.number_people > 0:
                for index in person_indices:
    
                    left = np.clip(rect_data[index][0] / np.float(HEIGHT), 0, 1)
                    top = np.clip(rect_data[index][1] / np.float(WIDTH), 0, 1)
                    right = np.clip(rect_data[index][2] / np.float(HEIGHT), 0, 1)
                    bottom = np.clip(rect_data[index][3] / np.float(WIDTH), 0, 1)
    
                    stream.add_rect(left, top, right, bottom)
                    stream.add_label(str(prob_data[index][0]), right, bottom)
            # Add text
            stream.add_label('Number of People : {}'.format(self.number_people), 0.8, 0.05)
            ...
            outputs.video_out[i] = stream
```

where \(`x_coordinate=0.1, y_coordinate=0.1`\) means the top\-left corner of the string is placed 10% of the width and hight away from the top\-left corner of the image frame\. If, for example, \(`x_coordinate=1.0, y_coordinate=1.0`\), the top\-left corner of the message label coincides with the bottom\-right corner of the image frame\. In this case, the added message label will become invisible\.