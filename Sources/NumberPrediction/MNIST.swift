//
// MNIST.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class MNISTInput : MLFeatureProvider {

    /// Image to analyze as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
    var image: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class MNISTOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// Array of predictions mapped to their indices as dictionary of 64-bit integers to doubles
    lazy var prediction: [Int64 : Double] = {
        [unowned self] in return self.provider.featureValue(for: "prediction")!.dictionaryValue as! [Int64 : Double]
    }()

    /// classLabel as integer value
    lazy var classLabel: Int64 = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")!.int64Value
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(prediction: [Int64 : Double], classLabel: Int64) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["prediction" : MLFeatureValue(dictionary: prediction as [AnyHashable : NSNumber]), "classLabel" : MLFeatureValue(int64: classLabel)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class MNIST {
    public var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: MNIST.self)
        return bundle.url(forResource: "MNIST", withExtension:"mlmodelc")!
    }

    /**
        Construct a model with explicit path to mlmodelc file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration
        - parameters:
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct a model with explicit path to mlmodelc file and configuration
        - parameters:
           - url: the file url of the model
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
        self.model = try MLModel(contentsOf: url, configuration: configuration)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as MNISTInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as MNISTOutput
    */
    func prediction(input: MNISTInput) throws -> MNISTOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as MNISTInput
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as MNISTOutput
    */
    func prediction(input: MNISTInput, options: MLPredictionOptions) throws -> MNISTOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return MNISTOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - image: Image to analyze as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 28 pixels wide by 28 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as MNISTOutput
    */
    func prediction(image: CVPixelBuffer) throws -> MNISTOutput {
        let input_ = MNISTInput(image: image)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface
        - parameters:
           - inputs: the inputs to the prediction as [MNISTInput]
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as [MNISTOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [MNISTInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [MNISTOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [MNISTOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  MNISTOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
