var i = 0

// Function makes the edit window show single form and hides file input
window.onload= () =>{
  if(window.location.href.indexOf("edit") > -1 ) {
    document.getElementById('switchButton').classList.toggle("hidden")
    document.getElementById("instructions").innerHTML = ""

    // Hide unnecessary information
    event_repeatmonday_input= document.getElementById("event_repeatmonday_input")
    event_repeatmonday= document.getElementById("event_repeatmonday")
    event_repeatmonday_input.classList.toggle("hidden")

    event_repeattuesday_input= document.getElementById("event_repeattuesday_input")
    event_repeattuesday= document.getElementById("event_repeattuesday")
    event_repeattuesday_input.classList.toggle("hidden")

    event_repeatwednesday_input= document.getElementById("event_repeatwednesday_input")
    event_repeatwednesday= document.getElementById("event_repeatwednesday")
    event_repeatwednesday_input.classList.toggle("hidden")

    event_repeatthursday_input= document.getElementById("event_repeatthursday_input")
    event_repeatthursday= document.getElementById("event_repeatthursday")
    event_repeatthursday_input.classList.toggle("hidden")

    event_repeatfriday_input= document.getElementById("event_repeatfriday_input")
    event_repeatfriday= document.getElementById("event_repeatfriday")
    event_repeatfriday_input.classList.toggle("hidden")

    event_repeatsaturday_input= document.getElementById("event_repeatsaturday_input")
    event_repeatsaturday= document.getElementById("event_repeatsaturday")
    event_repeatsaturday_input.classList.toggle("hidden")

    event_repeatsunday_input= document.getElementById("event_repeatsunday_input")
    event_repeatsunday= document.getElementById("event_repeatsunday")
    event_repeatsunday_input.classList.toggle("hidden")

    event_repeatweeks_input= document.getElementById("event_repeatweeks_input")
    event_repeatweeks= document.getElementById("event_repeatweeks")
    event_repeatweeks_input.classList.add("stringish")
    event_repeatweeks_input.classList.toggle("hidden")
    event_repeatweeks.type = ""
    event_repeatweeks.value = ""
  }
}

// // Changes form should a single event want to be added as opposed to multiple
function changeForm() {
  
  if(i % 2 == 0) {
    document.getElementById("switchButton").innerHTML = "Repeating Event"
    document.getElementById("instructions").innerHTML = "This event will only happen once"
    i++
  } else {
    document.getElementById("switchButton").innerHTML = "Non-Repeating Event"
    document.getElementById("instructions").innerHTML = "What days should the event repeat for?"
    i--
  }

  // toggles hidden for all elements, meaning Repeating information will be hidden
    event_repeatmonday_input= document.getElementById("event_repeatmonday_input")
    event_repeatmonday= document.getElementById("event_repeatmonday")
    event_repeatmonday_input.classList.toggle("hidden")

    event_repeattuesday_input= document.getElementById("event_repeattuesday_input")
    event_repeattuesday= document.getElementById("event_repeattuesday")
    event_repeattuesday_input.classList.toggle("hidden")

    event_repeatwednesday_input= document.getElementById("event_repeatwednesday_input")
    event_repeatwednesday= document.getElementById("event_repeatwednesday")
    event_repeatwednesday_input.classList.toggle("hidden")

    event_repeatthursday_input= document.getElementById("event_repeatthursday_input")
    event_repeatthursday= document.getElementById("event_repeatthursday")
    event_repeatthursday_input.classList.toggle("hidden")

    event_repeatfriday_input= document.getElementById("event_repeatfriday_input")
    event_repeatfriday= document.getElementById("event_repeatfriday")
    event_repeatfriday_input.classList.toggle("hidden")

    event_repeatsaturday_input= document.getElementById("event_repeatsaturday_input")
    event_repeatsaturday= document.getElementById("event_repeatsaturday")
    event_repeatsaturday_input.classList.toggle("hidden")

    event_repeatsunday_input= document.getElementById("event_repeatsunday_input")
    event_repeatsunday= document.getElementById("event_repeatsunday")
    event_repeatsunday_input.classList.toggle("hidden")

    event_repeatweeks_input= document.getElementById("event_repeatweeks_input")
    event_repeatweeks= document.getElementById("event_repeatweeks")
    event_repeatweeks_input.classList.add("stringish")
    event_repeatweeks_input.classList.toggle("hidden")
    event_repeatweeks.type = ""
    event_repeatweeks.value = ""
}
