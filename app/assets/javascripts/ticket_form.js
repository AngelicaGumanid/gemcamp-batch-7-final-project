document.addEventListener("DOMContentLoaded", () => {
    const decrementButtons = document.querySelectorAll(".decrement");
    const incrementButtons = document.querySelectorAll(".increment");

    decrementButtons.forEach((btn) =>
        btn.addEventListener("click", (event) => {
            const inputField = event.target.nextElementSibling;
            const currentValue = parseInt(inputField.value, 10) || 1;
            if (currentValue > 1) inputField.value = currentValue - 1;
        })
    );

    incrementButtons.forEach((btn) =>
        btn.addEventListener("click", (event) => {
            const inputField = event.target.previousElementSibling;
            const max = parseInt(inputField.getAttribute("max"), 10) || Infinity;
            const currentValue = parseInt(inputField.value, 10) || 1;
            if (currentValue < max) inputField.value = currentValue + 1;
        })
    );
});