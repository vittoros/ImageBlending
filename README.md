# ImageBlending
Mosaic creation of 2 images using [Harris Corners](https://en.wikipedia.org/wiki/Harris_Corner_Detector), 
[SIFT descriptors](https://en.wikipedia.org/wiki/Scale-invariant_feature_transform) and [RANSAC](https://en.wikipedia.org/wiki/Random_sample_consensus)

## Setup
This code uses VLFeat library, for creating the SIFT descriptors from the found Harris features. Instructions for the installation can be found [here](http://www.vlfeat.org/install-matlab.html).

## 2 Examples of usage
1st example
### Calculate the Harris Corners in the two images
![alt text](https://raw.githubusercontent.com/vittoros/ImageBlending/ReadmeImages/readmeImages/Harris1.jpg?raw=true)

### Find the matches
Calculate the SIFT descriptors using the Harris features. Then use vl_ubcmatch() to find the matches.
Lastly apply RANSAC to find the similarity transform that fits best. On the left the total matches found by vl_ubcmatch()
is shown, and on the right the biggest consensus set that fits the transform found by RANSAC.
![alt text](https://raw.githubusercontent.com/vittoros/ImageBlending/ReadmeImages/readmeImages/matches1.jpg?raw=true)

### Warp and Fuse
Lastly, invert the found transform and fuse two images
![alt text](https://raw.githubusercontent.com/vittoros/ImageBlending/ReadmeImages/readmeImages/final.png?raw=true)

2nd example
### Calculate the Harris Corners in the two images
![alt text](https://raw.githubusercontent.com/vittoros/ImageBlending/ReadmeImages/readmeImages/Harris2.jpg?raw=true)

### Find the matches
Calculate the SIFT descriptors using the Harris features. Then use vl_ubcmatch() to find the matches.
Lastly apply RANSAC to find the similarity transform that fits best. On the left the total matches found by vl_ubcmatch()
is shown, and on the right the biggest consensus set that fits the transform found by RANSAC.
![alt text](https://raw.githubusercontent.com/vittoros/ImageBlending/ReadmeImages/readmeImages/matches2.jpg?raw=true)

### Warp and Fuse
Lastly, invert the found transform and fuse two images
![alt text](https://raw.githubusercontent.com/vittoros/ImageBlending/ReadmeImages/readmeImages/final2.png?raw=true)
