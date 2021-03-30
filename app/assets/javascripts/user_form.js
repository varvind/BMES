var i = 0

// Function makes the edit window show single form and hides file input
window.onload= () =>{
  if(window.location.href.indexOf("edit") > -1 ) {
    document.getElementById('switchButton').classList.toggle("hidden")
    document.getElementById("instructions").innerHTML = "Fill in Inputs with User information"
    document.getElementById("columns").innerHTML = ""
    // Make name input viewable
    user_name_input= document.getElementById("user_name_input")
    user_name= document.getElementById("user_name")
    user_name_input.classList.add("stringish")
    user_name_input.classList.toggle("hidden")
    user_name.type = ""
    user_name.placeholder = "Name"
  
    // Make email input viewable
    user_email_input= document.getElementById("user_email_input")
    user_email= document.getElementById("user_email")
    user_email_input.classList.add("stringish")
    user_email_input.classList.toggle("hidden")
    user_email.type = ""
    user_email.placeholder = "Email"
  
    // Make user_total_points input viewable
    user_total_points_input= document.getElementById("user_total_points_input")
    user_total_points= document.getElementById("user_total_points")
    user_total_points_input.classList.add("stringish")
    user_total_points_input.classList.toggle("hidden")
    user_total_points.type = ""
    user_total_points.placeholder = "Total Points"
  
    // Make general meeting points input viewable
    user_general_meeting_points_input= document.getElementById("user_general_meeting_points_input")
    user_general_meeting_points= document.getElementById("user_general_meeting_points")
    user_general_meeting_points_input.classList.add("stringish")
    user_general_meeting_points_input.classList.toggle("hidden")
    user_general_meeting_points.type = ""
    user_general_meeting_points.placeholder = "General Meeting Points"
  
    // Make mentorship meeting points input viewable
    user_mentorship_meeting_points_input= document.getElementById("user_mentorship_meeting_points_input")
    user_mentorship_meeting_points= document.getElementById("user_mentorship_meeting_points")
    user_mentorship_meeting_points_input.classList.add("stringish")
    user_mentorship_meeting_points_input.classList.toggle("hidden")
    user_mentorship_meeting_points.type = ""
    user_mentorship_meeting_points.placeholder = "Mentorship Meeting Points"
    
    // Make social points input available
    user_social_points_input= document.getElementById("user_social_points_input")
    user_social_points= document.getElementById("user_social_points")
    user_social_points_input.classList.add("stringish")
    user_social_points_input.classList.toggle("hidden")
    user_social_points.type = ""
    user_social_points.placeholder = "Social Points"

    user_outreach_points_input= document.getElementById("user_outreach_points_input")
    user_outreach_points= document.getElementById("user_outreach_points")
    user_outreach_points_input.classList.add("stringish")
    user_outreach_points_input.classList.toggle("hidden")
    user_outreach_points.type = ""
    user_outreach_points.placeholder = "Outreach Points"

    user_active_semesters_input= document.getElementById("user_active_semesters_input")
    user_active_semesters_points= document.getElementById("user_active_semesters")
    user_active_semesters_points_input.classList.add("stringish")
    user_active_semesters_points_input.classList.toggle("hidden")
    user_active_semesters_points.type = ""
    user_active_semesters_points.placeholder = "Active Semesters"
  
    // make user CSV file input hidden
    user_CSV_file_input = document.getElementById("user_user_CSV_File_input")
    user_CSV_file = document.getElementById('user_user_CSV_File')
    user_CSV_file_input.classList.toggle("hidden")
    user_CSV_file.classList.toggle("hidden")
  }
}

// Changes form should a single user want to be added as opposed to multiple
function changeForm() {
  
  if(i % 2 == 0) {
    document.getElementById("switchButton").innerHTML = "Add Multiple Users"
    document.getElementById("instructions").innerHTML = "Fill in Inputs with User information"
    document.getElementById("columns").innerHTML = ""
    i++
  } else {
    document.getElementById("switchButton").innerHTML = "Add Individual User"
    document.getElementById("instructions").innerHTML = "Use a Spreadsheet with User Information"
    document.getElementById("columns").innerHTML = "Required Columns: Name, Email, Total Points, General Meeting Points, Mentorship Meeting Points, Outreach Points, Active Semesters and Social Points"
    i--
  }

  // toggles hidden for all elements, meaning some will hide and some will show depending on user choice
  user_name_input= document.getElementById("user_name_input")
  user_name= document.getElementById("user_name")
  user_name_input.classList.add("stringish")
  user_name_input.classList.toggle("hidden")
  user_name.type = ""
  user_name.placeholder = "Name"

  user_email_input= document.getElementById("user_email_input")
  user_email= document.getElementById("user_email")
  user_email_input.classList.add("stringish")
  user_email_input.classList.toggle("hidden")
  user_email.type = ""
  user_email.placeholder = "Email"

  user_total_points_input= document.getElementById("user_total_points_input")
  user_total_points= document.getElementById("user_total_points")
  user_total_points_input.classList.add("stringish")
  user_total_points_input.classList.toggle("hidden")
  user_total_points.type = ""
  user_total_points.value = ""
  user_total_points.placeholder = "Total Points"

  user_general_meeting_points_input= document.getElementById("user_general_meeting_points_input")
  user_general_meeting_points= document.getElementById("user_general_meeting_points")
  user_general_meeting_points_input.classList.add("stringish")
  user_general_meeting_points_input.classList.toggle("hidden")
  user_general_meeting_points.type = ""
  user_general_meeting_points.value = ""
  user_general_meeting_points.placeholder = "General Meeting Points"


  user_mentorship_meeting_points_input= document.getElementById("user_mentorship_meeting_points_input")
  user_mentorship_meeting_points= document.getElementById("user_mentorship_meeting_points")
  user_mentorship_meeting_points_input.classList.add("stringish")
  user_mentorship_meeting_points_input.classList.toggle("hidden")
  user_mentorship_meeting_points.type = ""
  user_mentorship_meeting_points.value = ""
  user_mentorship_meeting_points.placeholder = "Mentorship Meeting Points"

  user_social_points_input= document.getElementById("user_social_points_input")
  user_social_points= document.getElementById("user_social_points")
  user_social_points_input.classList.add("stringish")
  user_social_points_input.classList.toggle("hidden")
  user_social_points.type = ""
  user_social_points.value = ""
  user_social_points.placeholder = "Social Points"

  user_outreach_points_input= document.getElementById("user_outreach_points_input")
  user_outreach_points= document.getElementById("user_outreach_points")
  user_outreach_points_input.classList.add("stringish")
  user_outreach_points_input.classList.toggle("hidden")
  user_outreach_points.type = ""
  user_outreach_points.value = ""
  user_outreach_points.placeholder = "Outreach Points"

  user_active_semesters_input= document.getElementById("user_active_semesters_input")
  user_active_semesters= document.getElementById("user_active_semesters")
  user_active_semesters_input.classList.add("stringish")
  user_active_semesters_input.classList.toggle("hidden")
  user_active_semesters.type = ""
  user_active_semesters.value = ""
  user_active_semesters.placeholder = "Active Semesters"

  user_CSV_file_input = document.getElementById("user_user_CSV_File_input")
  user_CSV_file = document.getElementById('user_user_CSV_File')
  user_CSV_file_input.classList.toggle("hidden")
  user_CSV_file.classList.toggle("hidden")
}