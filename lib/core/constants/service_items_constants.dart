import 'package:car_maintenance_system_new/core/models/service_item_model.dart';
import 'package:car_maintenance_system_new/core/models/booking_model.dart';

class ServiceItemsConstants {
  // Predefined service items for Regular Maintenance
  static final List<ServiceItemModel> regularMaintenanceItems = [
    ServiceItemModel(
      id: 'oil_change',
      name: 'Oil Change',
      type: ServiceItemType.service,
      price: 35.00,
      description: 'Engine oil replacement',
    ),
    ServiceItemModel(
      id: 'oil_filter',
      name: 'Oil Filter',
      type: ServiceItemType.part,
      price: 12.99,
      description: 'Standard oil filter',
    ),
    ServiceItemModel(
      id: 'air_filter',
      name: 'Air Filter',
      type: ServiceItemType.part,
      price: 18.50,
      description: 'Engine air filter replacement',
    ),
    ServiceItemModel(
      id: 'cabin_filter',
      name: 'Cabin Air Filter',
      type: ServiceItemType.part,
      price: 22.00,
      description: 'AC cabin filter',
    ),
    ServiceItemModel(
      id: 'tire_rotation',
      name: 'Tire Rotation',
      type: ServiceItemType.service,
      price: 25.00,
      description: 'Rotate all four tires',
    ),
    ServiceItemModel(
      id: 'fluid_top_up',
      name: 'Fluid Top-Up',
      type: ServiceItemType.service,
      price: 15.00,
      description: 'Check and top up all fluids',
    ),
  ];

  // Predefined service items for Inspection
  static final List<ServiceItemModel> inspectionItems = [
    ServiceItemModel(
      id: 'basic_inspection',
      name: 'Basic Inspection',
      type: ServiceItemType.service,
      price: 50.00,
      description: 'Visual inspection of major components',
    ),
    ServiceItemModel(
      id: 'comprehensive_inspection',
      name: 'Comprehensive Inspection',
      type: ServiceItemType.service,
      price: 120.00,
      description: 'Detailed 100-point inspection',
    ),
    ServiceItemModel(
      id: 'brake_inspection',
      name: 'Brake System Inspection',
      type: ServiceItemType.service,
      price: 30.00,
      description: 'Inspect brake pads, rotors, and fluid',
    ),
    ServiceItemModel(
      id: 'tire_inspection',
      name: 'Tire Inspection',
      type: ServiceItemType.service,
      price: 20.00,
      description: 'Check tire tread depth and pressure',
    ),
    ServiceItemModel(
      id: 'battery_test',
      name: 'Battery Test',
      type: ServiceItemType.service,
      price: 15.00,
      description: 'Battery health check',
    ),
    ServiceItemModel(
      id: 'diagnostic_scan',
      name: 'Computer Diagnostic Scan',
      type: ServiceItemType.service,
      price: 75.00,
      description: 'OBD-II system scan',
    ),
  ];

  // Predefined service items for Repair
  static final List<ServiceItemModel> repairItems = [
    ServiceItemModel(
      id: 'brake_pads_front',
      name: 'Brake Pads (Front)',
      type: ServiceItemType.part,
      price: 85.00,
      description: 'Front brake pad set',
    ),
    ServiceItemModel(
      id: 'brake_pads_rear',
      name: 'Brake Pads (Rear)',
      type: ServiceItemType.part,
      price: 75.00,
      description: 'Rear brake pad set',
    ),
    ServiceItemModel(
      id: 'brake_rotors',
      name: 'Brake Rotors',
      type: ServiceItemType.part,
      price: 120.00,
      description: 'Brake rotor replacement (per pair)',
    ),
    ServiceItemModel(
      id: 'battery',
      name: 'Car Battery',
      type: ServiceItemType.part,
      price: 150.00,
      description: 'Standard car battery',
    ),
    ServiceItemModel(
      id: 'alternator',
      name: 'Alternator',
      type: ServiceItemType.part,
      price: 280.00,
      description: 'Alternator replacement',
    ),
    ServiceItemModel(
      id: 'starter_motor',
      name: 'Starter Motor',
      type: ServiceItemType.part,
      price: 220.00,
      description: 'Starter motor replacement',
    ),
    ServiceItemModel(
      id: 'spark_plugs',
      name: 'Spark Plugs (Set)',
      type: ServiceItemType.part,
      price: 45.00,
      description: 'Set of 4 spark plugs',
    ),
    ServiceItemModel(
      id: 'serpentine_belt',
      name: 'Serpentine Belt',
      type: ServiceItemType.part,
      price: 35.00,
      description: 'Engine serpentine belt',
    ),
    ServiceItemModel(
      id: 'timing_belt',
      name: 'Timing Belt',
      type: ServiceItemType.part,
      price: 180.00,
      description: 'Timing belt replacement',
    ),
    ServiceItemModel(
      id: 'radiator',
      name: 'Radiator',
      type: ServiceItemType.part,
      price: 250.00,
      description: 'Radiator replacement',
    ),
    ServiceItemModel(
      id: 'water_pump',
      name: 'Water Pump',
      type: ServiceItemType.part,
      price: 120.00,
      description: 'Coolant water pump',
    ),
    ServiceItemModel(
      id: 'brake_installation',
      name: 'Brake Installation',
      type: ServiceItemType.labor,
      price: 100.00,
      description: 'Install brake pads/rotors',
    ),
    ServiceItemModel(
      id: 'electrical_repair',
      name: 'Electrical Repair',
      type: ServiceItemType.labor,
      price: 120.00,
      description: 'Electrical system repair work',
    ),
  ];

  // Predefined service items for Emergency
  static final List<ServiceItemModel> emergencyItems = [
    ServiceItemModel(
      id: 'towing_service',
      name: 'Towing Service',
      type: ServiceItemType.service,
      price: 100.00,
      description: 'Emergency towing (base rate)',
    ),
    ServiceItemModel(
      id: 'roadside_assistance',
      name: 'Roadside Assistance',
      type: ServiceItemType.service,
      price: 75.00,
      description: 'On-site emergency assistance',
    ),
    ServiceItemModel(
      id: 'jump_start',
      name: 'Jump Start Service',
      type: ServiceItemType.service,
      price: 40.00,
      description: 'Battery jump start',
    ),
    ServiceItemModel(
      id: 'tire_change',
      name: 'Flat Tire Change',
      type: ServiceItemType.service,
      price: 50.00,
      description: 'Change flat tire with spare',
    ),
    ServiceItemModel(
      id: 'lockout_service',
      name: 'Car Lockout Service',
      type: ServiceItemType.service,
      price: 60.00,
      description: 'Unlock car door',
    ),
    ServiceItemModel(
      id: 'fuel_delivery',
      name: 'Fuel Delivery',
      type: ServiceItemType.service,
      price: 45.00,
      description: 'Emergency fuel delivery',
    ),
    ServiceItemModel(
      id: 'emergency_diagnostic',
      name: 'Emergency Diagnostic',
      type: ServiceItemType.service,
      price: 90.00,
      description: 'Quick diagnostic for breakdown',
    ),
  ];

  // Labor cost presets
  static final Map<MaintenanceType, double> defaultLaborCosts = {
    MaintenanceType.regular: 50.00,
    MaintenanceType.inspection: 40.00,
    MaintenanceType.repair: 80.00,
    MaintenanceType.emergency: 100.00,
  };

  // Get items for a specific maintenance type
  static List<ServiceItemModel> getItemsForType(MaintenanceType type) {
    switch (type) {
      case MaintenanceType.regular:
        return regularMaintenanceItems;
      case MaintenanceType.inspection:
        return inspectionItems;
      case MaintenanceType.repair:
        return repairItems;
      case MaintenanceType.emergency:
        return emergencyItems;
    }
  }

  // Get default labor cost for maintenance type
  static double getDefaultLaborCost(MaintenanceType type) {
    return defaultLaborCosts[type] ?? 60.00;
  }
}



