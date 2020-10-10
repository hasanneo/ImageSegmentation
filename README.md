# ImageSegmentation
 The flow of this project starts with an input image and then calculating the scale at each pixel of the input image and then extracting the color and texture features and then clustering the features by using EM to fit Gaussian Mixtures.
![alt text](https://raw.githubusercontent.com/hasanneo/ImageSegmentation/master/images/flow.jpg)

Firstly, we go over the color features. The color features that are discussed in the approach are the coordinates in the L*a*b* color space also known as the CIELAB color space L* for the lightness from black (0) to white (100), a* from green (−) to red (+),b* from blue (−) to yellow (+).We have implemented the approach in Matlab, so to do this we used a built-in function that converts RGB to L*a*b*.

Secondly, it is required to smooth the features to avoid using over segmentation arising from local color variations due to texture. A scale selection method was presented in the paper which is based on the local image property known as polarity. The polarity is a measure of the extent to which the gradient vectors of the image in a certain neighborhood all point in the same direction. The process of scale selection is based on the derivative of polarity with respect to scale σ_k=k/2 ,k=0,1,...7 and this method can be found in our Matlab code under the method name scaleSelection(inimage) where inimage is the L* values of the input image and this method uses a helper method computePolarity(inimage,scale) that also takes the L* component of the image and scale σ_k that was described.

Thirdly, we compute the texture features that are anisotropy polarity and contrast of the input image. Using the definitions of these features from the paper 
Polarity is p=p_(σ*) where σ^* is the selected scale (output of scaleSelection(inimage)). Anisotropy is defined as 1-λ_2/λ_1  where λ_2 is the greater eigenvalue and λ_1 is the lesser eigenvalue of the second moment matrix calculated at the selected scale. Finally Contrast is given by 2√(λ_1+λ_2). These three features are calculated at the method computeBlobworldFeatureVectors(inimage); it takes as an input the matrix of the image as RGB.

Fourthly, after computing the scale and BlobWorld features we use the Expectation Maximization algorithm to fit the features we computed above into Gaussian Mixtures. The implementation of this part is in the gaussianMixEmFit(X, nKernels) method where it takes X as matrix of (:,:,6) matrix of L, a, b, polarity, anisotropy, contrast features. And nKernels as the number of Gaussian Mixtures. The output of this method are the parameters of the Gaussians mean vectors, covariance matrices, weights of the mixture and expectations of latent variables 'z'.

After the clustering we produce a label matrix group_mat having the cluster label for each (x,y) pixel in the original image. After that we solve for region boundaries for the clusters by using boundarymask(label_mat) which is a built-in function in Matlab that finds the region boundaries of the segmentation and it takes a label matrix. We pass this method our group_mat then we show the original image with drawn the boundaries.

# Results
First we present the obtained results of the scaled image after executing scaleSelection and then doing a Gaussian convolution using smoothVariantScale(inimage,scaleMat) . smoothVariantScale is a method that is implemented in our Matlab code that Smooths image 'inimage' using a different smoothing scale for each pixel.
![alt text](https://raw.githubusercontent.com/hasanneo/ImageSegmentation/master/images/smoothed.jpg)

Secondly, we show the six components of the color/texture feature vectors. Starting with the smoothed L*a*b* components (from left to right L*a*b*):
![alt text](https://raw.githubusercontent.com/hasanneo/ImageSegmentation/master/images/color.jpg)

Then we have the texture features anisotropy polarity and contrast that are calculated using computePolarity(inimage, scale) which takes the L* component of the input image and the scale that we have computed previously . This method returns the polarity of the image that was defined in the paper which was mentioned above and also it return the eigenvalues λ_1>λ_2 which are used to calculate the anisotropy and contrast that were defined in the previous section.
![alt text](https://raw.githubusercontent.com/hasanneo/ImageSegmentation/master/images/texture.jpg)
