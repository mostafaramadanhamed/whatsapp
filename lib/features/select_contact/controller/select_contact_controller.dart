import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/select_contact/repository/select_contact_repository.dart';

final getContactsProvider=FutureProvider((ref) {
    final SelectContactRepository selectContactRepository=ref.watch(selectContactRepositoryProvider);
    return selectContactRepository.getContacts();
});