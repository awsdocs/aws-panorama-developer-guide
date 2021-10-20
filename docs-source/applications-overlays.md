# Adding text and boxes to output video<a name="applications-overlays"></a>

With the AWS Panorama SDK, you can output a video stream to a display\. The video can include text and boxes that show output from the model, the current state of the application, or other data\.

Each object in the `video_in` array is an image from a camera stream that is connected to the appliance\. The type of this object is `panoramasdk.media`\. It has methods to add text and rectangular boxes to the image, which you can then assign to the `video_out` array\.

In the following example, the sample application adds a label for each of the results\. Each result is positioned at the same left position, but at different heights\.

```
        for j in range(max_results):
            label = 'Class [%s], with probability %.3f.'% (self.classes[indexes[j]], class_tuple[0][indexes[j]])
            stream.add_label(label, 0.1, 0.1 + 0.1*j)
```

To add a box to the output image, use `add_rect`\. This method takes 4 values between 0 and 1, indicating the position of the top left and bottom right corners of the box\.

```
        w,h,c = stream.image.shape
        stream.add_rect(x1/w, y1/h, x2/w, y2/h)
```

For more information about the AWS Panorama application SDK, see [The AWS Panorama Application SDK](applications-panoramasdk.md)\.