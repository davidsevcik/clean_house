$ ->
  membersInput = $('#shift_member_token_ids')
  if membersInput.size()
    memberIds = membersInput.attr('value').split(',')
    # $.getJSON '<%= Rails.application.routes.url_helpers.members_path(scope: "actives") %>', (json) ->
    $.getJSON '/members?scope=actives', (json) ->
      membersInput.tokenInput(
        json
        prePopulate: $.grep(json, (member) -> memberIds.indexOf(String(member.id)) isnt -1)
        hintText: 'Napište několik písmen jména'
      )