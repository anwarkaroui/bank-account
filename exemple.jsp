function checkProviderName(input, index) {
  const regex = /^[0-9a-zA-Z\-_ ]{3,32}$/;
  const feedback = document.getElementById("providerNameFeedback_" + index);

  const isValid = regex.test(input.value);

  input.classList.toggle("is-valid", isValid);
  input.classList.toggle("is-invalid", !isValid);

  feedback.style.display = isValid ? "none" : "block";
}