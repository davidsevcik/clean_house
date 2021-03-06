$(function() {
  var memberIds, membersInput;
  membersInput = $('#shift_member_token_ids');
  if (membersInput.size()) {
    memberIds = membersInput.attr('value').split(',');
    return $.getJSON('/members?scope=actives', function(json) {
      return membersInput.tokenInput(json, {
        prePopulate: $.grep(json, function(member) {
          return memberIds.indexOf(String(member.id)) !== -1;
        }),
        hintText: 'Napište několik písmen jména'
      });
    });
  }
});
