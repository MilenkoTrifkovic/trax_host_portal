import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trax_host_portal/controller/admin_controllers/organisation_info_controller.dart';
import 'package:trax_host_portal/view/admin/organisation_info_popup/widgets/forms/sales_person_ref_form.dart';
import 'package:trax_host_portal/view/admin/organisation_info_popup/widgets/forms/location_time_form.dart';
import 'package:trax_host_portal/view/admin/organisation_info_popup/widgets/forms/restaurant_info_form.dart';

class StepContent extends StatelessWidget {
  const StepContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrganisationInfoController>();

    return Obx(() => _buildStepContent(controller.currentStep.value));
  }

  Widget _buildStepContent(int currentStep) {
    switch (currentStep) {
      case 0:
        return const SalesPersonRefForm();
      case 1:
        return const LocationTimeForm();
      case 2:
        return const RestaurantInfoForm();
      default:
        return const SizedBox();
    }
  }
}
