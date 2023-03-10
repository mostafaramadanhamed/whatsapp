import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/select_contact/repository/select_contact_repository.dart';

final getContactsProvider=FutureProvider((ref) {
    final SelectContactRepository selectContactRepository=ref.watch(selectContactRepositoryProvider);
    return selectContactRepository.getContacts();
});
final selectContactControllerProvider=Provider((ref) {
   final  selectContactRepository =ref.watch(selectContactRepositoryProvider);
   return SelectContactController(
       ref: ref,
       selectContactRepository: selectContactRepository,
   );
});
class SelectContactController{
    final ProviderRef ref;
    final SelectContactRepository selectContactRepository;

  SelectContactController({
      required this.ref,
      required this.selectContactRepository,
  });
void selectContact(BuildContext context, Contact selectedContact){
    selectContactRepository.selectContact(selectedContact, context);
}
}