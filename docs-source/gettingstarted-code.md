# Sample application code<a name="gettingstarted-code"></a>

The following example shows a Python function that processes video feeds from one or more camera streams \(`video_in`\)\. It loops over frames of video, detects people, and outputs the original video with an overlay that includes the number of people detected, and bounding boxes around each person\.

**Example [lambda\_function\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/code/lambda_function.py) – Processing video**  

```
class people_counter(panoramasdk.base):
    ...
    def entry(self, inputs, outputs):
        self.frame_num += 1

        for i in range(len(inputs.video_in)):
            stream = inputs.video_in[i]
            person_image = stream.image
            stream.add_label('People detected: {}'.format(self.number_people), 0.8, 0.05)

            # Prepare the image and run inference
            x1 = self.preprocess(person_image)
            self.model.batch(0, x1)
            self.model.flush()
            resultBatchSet = self.model.get_result()

            # Process results
            class_batch = resultBatchSet.get(0)
            prob_batch = resultBatchSet.get(1)
            rect_batch = resultBatchSet.get(2)

            class_batch.get(0, self.class_array)
            prob_batch.get(0, self.prob_array)
            rect_batch.get(0, self.rect_array)

            class_data = self.class_array[0]
            prob_data = self.prob_array[0]
            rect_data = self.rect_array[0]
            
            # Get indices of people classes
            person_indices = self.get_number_persons(class_data,prob_data)
            
            try:
                self.number_people = len(person_indices)
            except:
                self.number_people = 0

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
            stream.add_label('People detected: {}'.format(self.number_people), 0.8, 0.05)
            
            self.model.release_result(resultBatchSet)
            outputs.video_out[i] = stream

        return True
```

For sample applications that you can run on the AWS Panorama Appliance Developer Kit, visit the [aws\-panorama\-samples](https://github.com/aws-samples/aws-panorama-samples) repository on GitHub\.