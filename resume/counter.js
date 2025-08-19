document.addEventListener('DOMContentLoaded',()=>{
    let ele = document.getElementById('visit_count');
    let current = localStorage.getItem('visit_counter') ?? 0; // Nullish coalescing
    /*     if(Number(isFinite(current)){
        next = Number(current)+ 1;
    }else{
        next = 1;
    } */
    let next = Number(isFinite(current)) ? Number(current) + 1: 1; //ternary operator. if/else
    localStorage.setItem('visit_counter',String(next));
    ele.textContent = String(next);
})