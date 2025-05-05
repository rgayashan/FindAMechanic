import UIKit
import MapKit

/// A base class for handling MKMapViewDelegate
class MapViewDelegateHandler: NSObject, MKMapViewDelegate {
    
    // MARK: - Properties
    
    weak var mapView: MKMapView?
    
    // MARK: - Initialization
    
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        
        setupMapView()
    }
    
    // MARK: - Setup
    
    private func setupMapView() {
        mapView?.delegate = self
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Default implementation to be overridden by subclasses
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let identifier = "StandardPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // To be overridden by subclasses for specific selection handling
    }
    
    // MARK: - Public Methods
    
    /// Centers the map on a specific coordinate with a span
    /// - Parameters:
    ///   - coordinate: The coordinate to center on
    ///   - span: The span of the region (defaults to medium zoom)
    func centerMap(on coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)) {
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView?.setRegion(region, animated: true)
    }
    
    /// Adds an annotation to the map
    /// - Parameter annotation: The annotation to add
    func addAnnotation(_ annotation: MKAnnotation) {
        mapView?.addAnnotation(annotation)
    }
    
    /// Adds multiple annotations to the map
    /// - Parameter annotations: The annotations to add
    func addAnnotations(_ annotations: [MKAnnotation]) {
        mapView?.addAnnotations(annotations)
    }
    
    /// Removes all annotations from the map except the user location
    func removeAllAnnotations() {
        guard let annotations = mapView?.annotations else { return }
        
        let annotationsToRemove = annotations.filter { !($0 is MKUserLocation) }
        mapView?.removeAnnotations(annotationsToRemove)
    }
    
    /// Shows user location on the map
    /// - Parameter show: Whether to show the user location
    func showUserLocation(_ show: Bool) {
        mapView?.showsUserLocation = show
    }
} 