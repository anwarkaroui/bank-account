function checkProviderName(input, index) {
  const regex = /^[0-9a-zA-Z\-_ ]{3,32}$/;
  const feedback = document.getElementById("providerNameFeedback_" + index);

  const isValid = regex.test(input.value);

  input.classList.toggle("is-valid", isValid);
  input.classList.toggle("is-invalid", !isValid);

  feedback.style.display = isValid ? "none" : "block";
}






<script type="text/javascript">
  var csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute("content");
  var csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute("content");

  function isValidProviderName(value) {
    return /^[0-9a-zA-Z\-_ ]{3,32}$/.test((value || "").trim());
  }

  function checkProviderName(input, index) {
    const regex = /^[0-9a-zA-Z\-_ ]{3,32}$/;
    const feedback = document.getElementById("providerNameFeedback_" + index);

    const isValid = regex.test(input.value);

    input.classList.toggle("is-valid", isValid);
    input.classList.toggle("is-invalid", !isValid);

    feedback.style.display = isValid ? "none" : "block";
    input.style.borderColor = isValid ? "green" : "red";
  }

  function toggleButton(index){
    const checkbox = document.getElementById('chk-enable-' + index);
    const button = document.getElementById('btn-validate-'+ index);
    button.disabled = !checkbox.checked;
  }

  function validate(btn, index) {
    const input = document.getElementById("providerName_" + index);
    const providerName = input.value;

    // Cache les autres alertes
    $('#alert-success').hide();
    $('#alert-error').hide();
    $('#alert-error-input').hide();

    // Re-valider au clic (important !)
    if (!isValidProviderName(providerName)) {
      // met l’input en erreur + feedback inline
      checkProviderName(input, index);

      // affiche l’alerte globale
      $('#alert-error-input').show();
      setTimeout(function(){ $('#alert-error-input').hide(); }, 4000);

      // STOP: pas d'exécution / pas de fetch
      return;
    }

    const providerId = btn.getAttribute('data-id');
    const providerOldName = btn.getAttribute('data-name');

    fetch("${root}trags/validate",{
      method:"POST",
      headers: {
        "Content-type": "application/json",
        [csrfHeader]: csrfToken
      },
      body: JSON.stringify({
        providerId: providerId,
        providerName: providerName,
        providerOldName: providerOldName
      })
    })
    .then(res => {
      $('#alert-error').hide();
      $('#alert-success').show();
      setTimeout(function(){ $('#alert-success').hide(); }, 4000);
    })
    .catch(err => {
      $('#alert-success').hide();
      $('#alert-error').show();
      setTimeout(function(){ $('#alert-error').hide(); }, 4000);
    });
  }
</script>

<div class="row">
            <div class="col-xs-12">
                <table class="table table-striped hover nowrap-table-title" id="tokenRequestors-list">
                    <thead>
                    <tr>
                        <th><spring:message code="type.token.requestor"/></th>
                        <th><spring:message code="id.connection.client" /></th>
                        <th><spring:message code="name.merchant" /></th>
                        <th><spring:message code="name.tr.aggregator" /></th>
                        <th><spring:message code="id.tr.aggregator" /></th>
                        <th><spring:message code="siret" /></th>
                        <th><spring:message code="initial.status" /></th>
                        <th><spring:message code="current.status" /></th>
                        <th><spring:message code="hub" /></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="result" items="${results}">

                        <tr>
                            <td>${result.tokenType}</td>
                            <td>${result.customerConnectionId}</td>
                            <td>${result.tokenName}</td>
                            <td>${result.providerName}</td>
                            <td>${result.providerId}</td>
                            <td>${result.siret}</td>
                            <td>${result.initialStatus}</td>
                            <td>${result.currentStatus}</td>
                            <td>${result.hub}</td>
                        </tr

                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
