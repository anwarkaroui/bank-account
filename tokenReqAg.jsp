<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<spring:url value="/" var="root" />
<spring:url value="/resources/js/" var="rootjs" />
<spring:url value="/resources/css/" var="rootcss" />

<tiles:insertDefinition name="base.definition">
    <tiles:putAttribute name="meta">
    <meta name="_csrf" content="${_csrf.token }" />
        <meta name="_csrf_header" content="${_csrf.headerName }" />
    </tiles:putAttribute>
    <tiles:putAttribute name="title"><spring:message code="list.tokenRequestors" /></tiles:putAttribute>
    <tiles:putAttribute name="stylecss" >
        <link href="${rootcss}jquery.dataTables.min.css" rel="stylesheet">
    </tiles:putAttribute>
    <tiles:putAttribute name="body">
        <style>
        /* Style pour le toggle switch */
        .toggle-switch {
        position: relative;
        display: inline-block;
        width: 40px;
        height: 20px;
        appearance: none;
        background-color: #ccc;
        border-radius: 20px;
        transition: .4s;
        vertical-align: middle;
        margin: 0 5px 0 0;
        }

        .toggle-switch:checked {
        background-color: #66bb6a;
        }

        .toggle-switch:before {
        position: absolute;
        content: "";
        height: 16px;
        width: 16px;
        left: 2px;
        bottom: 2px;
        background-color: white;
        border-radius: 50%;
        transition: .4s;
        }

        .toggle-switch:checked:before {
        transform: translateX(20px);
        }
        </style>
        <div class="row">
            <div class="alert alert-success" id="alert-success"
                 style="display: none">
			<span class="glyphicon glyphicon-exclamation-sign"
                  aria-hidden="true"></span> <span><spring:message code="update.success.message" /><br /></span>
            </div>
            <div class="alert alert-danger" id="alert-error"
                 style="display: none">
			<span class="glyphicon glyphicon-exclamation-sign"
                  aria-hidden="true"></span><spring:message code="update.error.message" /><br /></span>
            </div>
            <div class="alert alert-danger" id="alert-error-input"
                 style="display: none">
			<span class="glyphicon glyphicon-exclamation-sign"
                  aria-hidden="true"></span><spring:message code="invalid.provider.name" /><br /></span>
            </div>
            <div class="col-xs-12 text-center">
                <h3><spring:message code="list.tokenRequestors" /></h3><hr/><br/>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12">
                <table class="table table-striped hover nowrap-table-title" id="tokenRequestors-list">
                    <thead>
                    <tr>
                        <th><spring:message code="token.requestor.aggregator.id"/></th>
                        <th><spring:message code="token.requestor.aggregator.name" /></th>
                        <th><spring:message code="token.requestor.aggregator.number" /></th>
                        <th><spring:message code="token.requestor.aggregator.hub" /></th>
                        <th class="cell-width-44"><spring:message code="token.requestor.aggregator.action" /></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="tokenRequestor" items="${tokenRequestorAggregators}" varStatus="satus">

                        <tr>
                            <td>${tokenRequestor.providerId}</td>
                            <td><span class="hide">${tokenRequestor.providerName}</span>
                                <input type="text" value="${tokenRequestor.providerName}" name="providerName" id="providerName_${satus.index}"
                                         class="form-control" oninput="checkProviderName(this,${satus.index})">
                                <div id="providerNameFeedback_${satus.index}" class="invalid-feedback" style="display: none; color:red;">
                                    <spring:message code="invalid.provider.name"  /></div>
                            </td>
                            <td>${tokenRequestor.number}</td>
                            <td></td>
                                <td class="cell-width-44">
                                    <label for="chk-enable"></label><input
                                            type="checkbox"
                                            name="chk-enable-${satus.index}"
                                            class="toggle-switch"
                                            onchange="toggleButton(${satus.index})"
                                            id="chk-enable-${satus.index}"/>
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button class="btn btn-success" data-id="${tokenRequestor.providerId}" id="btn-validate-${satus.index}"
                                                    data-name="${tokenRequestor.providerName}" onclick="validate(this,${satus.index})" disabled>valider</button>
                                </td>
                        </tr

                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

	</tiles:putAttribute>
    <tiles:putAttribute name="scriptjs">
        <script type="text/javascript" src="${rootjs}jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="${rootjs}dataTables.bootstrap.min.js"></script>
        <script type="text/javascript">
            jQuery.extend( jQuery.fn.dataTableExt.oSort, {
                "title-string-pre": function ( a ) {
                    return a.match(/title="(.*?)"/)[1].toLowerCase();
                },
                "title-string-asc": function ( a, b ) {
                    return ((a < b) ? -1 : ((a > b) ? 1 : 0));
                },
                "title-string-desc": function ( a, b ) {
                    return ((a < b) ? 1 : ((a > b) ? -1 : 0));
                }
            });

            $(document).ready(function(){
                $('#tokenRequestors-list').DataTable({
                    language: {url : "${rootjs}/dataTables.<spring:message code="datatable.language.name" />.json"},
                    lengthMenu : [[10, 25, 50, 100, -1], [10, 25, 50, 100, "<spring:message code="all" />"]],
                    columnDefs: [
                        {
                            orderable: false,
                            searchable: false
                        }
                    ],
                    order: [[0, 'asc']]
                });

            });
            var csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute("content");
            var csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute("content");
            function checkProviderName(input, index) {
                const regex = /^[0-9a-zA-Z\-_ ]{3,32}$/;
                const feedback = document.getElementById("providerNameFeedback_" + index);

                const isValid = regex.test(input.value);

                input.classList.toggle("is-valid", isValid);
                input.classList.toggle("is-invalid", !isValid);

                feedback.style.display = isValid ? "none" : "block";
                input.style.borderColor = isValid ? "green" : "red";
            }
            /*function isValidProviderName(value) {
                return /^[0-9a-zA-Z\-_ ]{3,32}$/.test(value);
            }
            function checkProvider(inputId, errorId) {
                var input = document.getElementById(inputId);
                var error = document.getElementById(errorId);
                    setValidationState(input, error, isValidProviderName(input.value));
            }
            function setValidationState(input, error, isValid) {
                if (isValid) {
                    input.style.border = "2px solid green";
                    error.style.display = "none";
                } else {
                    input.style.border = "2px solid red";
                    error.style.display = "block";
                    error.style.color = "red";
                }
            }*/
            function toggleButton(index){
                const checkbox = document.getElementById('chk-enable-' + index);
                const button = document.getElementById('btn-validate-'+ index);
                button.disabled = !checkbox.checked;
            }
            function validate(data,index) {
                const providerId = data.getAttribute('data-id')
                var providerName = document.getElementById("providerName_"+index).value;
                const providerOldName = data.getAttribute('data-name')
                console.log(providerName);
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
                }).then(res =>{
                    console.log(res);
                    $('#alert-error').hide();
                    $('#alert-success').show();
                    setTimeout( "$('#alert-success').hide();", 4000);
                }).catch(err =>{
                    $('#alert-success').hide();
                    $('#alert-error').show();
                    setTimeout("$('#alert-error').hide();", 4000);
                })
            }
        </script>
        <script src="${rootjs}validate.js" type="text/javascript"></script>
</tiles:putAttribute>
</tiles:insertDefinition>


Parfait 👍 c’est surtout du front JSP/HTML/CSS. Voilà comment faire proprement.
1️⃣ Remplacer “Choose file” par une icône 📎
On cache l’input type="file" natif et on déclenche le clic via un label stylé.
JSP / HTML
Copier le code
Jsp
<form method="post" enctype="multipart/form-data"
      action="<c:url value='/changestatus/import'/>">

    <input type="file" id="fileUpload" name="file" accept=".csv" required hidden />

    <label for="fileUpload" class="file-label">
        <i class="glyphicon glyphicon-paperclip"></i>
        <span id="file-name">Aucun fichier choisi</span>
    </label>

    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

    <a href="#" onclick="this.closest('form').submit()" class="import-link">
        Changement du statut
    </a>
</form>
2️⃣ Traduire “No file chosen” → “Aucun fichier choisi”
On le fait en JavaScript, car ce texte vient du navigateur.
Copier le code
Html
<script>
document.getElementById("fileUpload").addEventListener("change", function () {
    const fileName = this.files.length > 0
        ? this.files[0].name
        : "Aucun fichier choisi";
    document.getElementById("file-name").textContent = fileName;
});
</script>
3️⃣ Remplacer le bouton Importer par un lien
Déjà fait ci-dessus avec :
Copier le code
Html
<a href="#" onclick="this.closest('form').submit()" class="import-link">
    Changement du statut
</a>
4️⃣ Un peu de CSS (important pour le rendu)
Copier le code
Css
.file-label {
    cursor: pointer;
    color: #337ab7;
    font-weight: 500;
}

.file-label i {
    margin-right: 6px;
}

.import-link {
    margin-left: 15px;
    text-decoration: underline;
    color: #5cb85c;
    cursor: pointer;
}

.import-link:hover {
    color: #449d44;
}
✅ Résultat final
📎 Icône pour joindre un fichier
🇫🇷 “Aucun fichier choisi”
🔗 Lien “Changement du statut” au lieu d’un bouton
Aucun impact backend / Spring / CSRF
Si tu veux :
Font Awesome au lieu de glyphicon
empêcher l’envoi sans fichier avec un message custom
ou un style Bootstrap plus clean
👉 dis-moi 😄
