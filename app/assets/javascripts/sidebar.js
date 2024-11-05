/*==================== SHOW NAVBAR ====================*/
const showMenu = (headerToggle, navbarId) =>{
    const toggleBtn = document.getElementById(headerToggle),
        nav = document.getElementById(navbarId)

    // Validate that variables exist
    if(headerToggle && navbarId){
        toggleBtn.addEventListener('click', ()=>{
            // We add the show-menu class to the div tag with the nav__menu class
            nav.classList.toggle('show-menu')
            // change icon
            toggleBtn.classList.toggle('bx-x')
        })
    }
}
showMenu('header-toggle','navbar')

/*==================== LINK ACTIVE ====================*/
const linkColor = document.querySelectorAll('.nav__link')

function colorLink(){
    linkColor.forEach(l => l.classList.remove('active'))
    this.classList.add('active')
}

linkColor.forEach(l => l.addEventListener('click', colorLink))

const navDropdown = document.querySelectorAll(".nav__dropdown");
for (let i = 0; i < navDropdown.length; i++) {
    navDropdown[i].addEventListener("click", () =>
        navDropdown[i].classList.toggle("open")
    );
}

const main = document.querySelector("main");
main.addEventListener("mousemove", (e) => {
    for (let i = 0; i < navDropdown.length; i++) {
        navDropdown[i].classList.remove("open");
    }
});