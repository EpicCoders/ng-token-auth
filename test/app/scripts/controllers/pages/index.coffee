angular.module('ngTokenAuthTestApp')
  .controller 'IndexCtrl', ($scope, $auth, $http, $modal, $q) ->
    $scope.accessRestrictedRoute = ->
      $http.get($auth.apiUrl() + '/demo/members_only')
        .success((resp) -> alert(resp.data.message))
        .error((resp) -> alert(resp.errors[0]))


    $scope.restrictedRoutesBatch = ->
      $q.all([
        $http.get($auth.apiUrl() + '/demo/members_only')
        $http.get($auth.apiUrl() + '/demo/members_only')
      ])
        .then((resp) -> alert('Multiple requests succeeded'))
        .catch((resp) -> alert('Multiple requests failed'))


    $scope.$on('auth:registration-email-success', (ev, data) ->
      $modal({
        title: "Success"
        html: true
        content: "<div id='alert-registration-email-sent'>A registration email was "+
          "sent to " + data.email + ". follow the instructions contained in the "+
          "email to complete registration.</div>"
      })

      delete $scope.registrationForm[field] for field, val of $scope.registrationForm
    )

    $scope.$on('auth:registration-email-error', (ev, data) ->
      $modal({
        title: "Error"
        html: true
        content: "<div id='alert-registration-email-failed'>Unable to send email "+
          "registration: " + _.map(data.errors).toString() + "</div>"
      })
    )

    $scope.$on('auth:password-reset-success', (ev, params) ->
      $modal({
        title: "Success"
        html: true
        content: "<div id='alert-password-reset-failed'>Password reset "+
          "instructions have been sent to " + params.email + "</div>"
      })
    )

    $scope.$on('auth:password-reset-failed', (ev, data) ->
      $modal({
        title: "Error"
        html: true
        content: "<div id='alert-password-reset-failed'>Error: "+
          _.map(data.errors).toString() + "</div>"
      })
    )

    passwordChangeModal = $modal({
      title: "Change your password!"
      html: true
      show: false
      contentTemplate: 'partials/password-reset-modal.html'
    })

    passwordChangeSuccessModal = $modal({
      title: "Success"
      html: true
      show: false
      content: "<div id='alert-password-change-success'>Your password "+
        "has been successfully updated."
    })

    passwordChangeErrorScope = $scope.$new()
    passwordChangeErrorModal = $modal({
      title: "Error"
      html: true
      show: false
      scope: passwordChangeErrorScope
      contentTemplate: 'partials/password-change-error-modal.html'
    })

    $scope.showPasswordChangeModal = -> passwordChangeModal.show()

    $scope.$on('auth:password-reset-prompt', -> passwordChangeModal.show())

    $scope.$on('auth:password-change-success', ->
      console.log 'password change success'
      passwordChangeModal.hide()
      passwordChangeSuccessModal.show()
    )

    $scope.$on('auth:password-change-error', (ev, data) ->
      console.log 'password change failed'
      passwordChangeErrorScope.errors = data.errors
      passwordChangeModal.hide()
      passwordChangeErrorModal.show()
    )

    passwordChangeErrorScope.$on('modal.hide', ->
      passwordChangeModal.show()
    )

    $scope.$on('auth:login', (ev, user) ->
      $modal({
        title: "Success"
        html: true
        content: "<div id='alert-auth-login'>Welcome back " + user.email + '</div>'
      })

      delete $scope.loginForm[field] for field, val of $scope.loginForm
      delete $scope.registrationForm[field] for field, val of $scope.registrationForm
    )

    $scope.$on('auth:failure', (ev, data) ->
      $modal({
        title: "Error"
        html: true
        content: "<div id='alert-failure'>Authentication failure: " +
          data.errors[0] + '</div>'
      })
    )

    $scope.$on('auth:logout-success', (ev) ->
      $modal({
        title: 'Success'
        html: true
        content: "<div id='alert-logout-success'>Goodbye</div>"
      })
    )

    $scope.$on('auth:logout-failure', (ev) ->
      $modal({
        title: 'Error'
        html: true
        content: "<div id='alert-logout-failure'>Unable to complete logout. "+
          "Please try again.</div>"
      })
    )
