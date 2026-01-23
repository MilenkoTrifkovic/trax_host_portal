import 'package:trax_host_portal/models/organisation_user_role.dart';
import 'package:trax_host_portal/models/user_model.dart';

class UserWithRole {
  final UserModel user;
  final OrganisationUserRole role;

  UserWithRole({required this.user, required this.role});
}
