$(document).keyup(function(e) {
	if (e.key === "Escape") {
	  $.post('http://flap_police_job/close', JSON.stringify({}));
    }
});

$(document).ready(function() {
	window.addEventListener('message', function(event) {
		var item = event.data;
		if (item.yrp_cloakroom == true) {
            $('.cloakroom-menu').css('display', 'block');
        } else if (item.yrp_cloakroom_keys == true) {
            $('.cloakroom_keys-menu').css('display', 'block');
        } else if (item.yrp_bossmenu == true) {
            $('.bossmenu').css('display', 'block');
            $('.choose_9').css('display', 'block');
            $('.choose_10').css('display', 'block');
        } else if (item.yrp_manage_money_wash == true) {
            $('.manage_money').css('display', 'block');
            $('.choose_11').css('display', 'block');
            $('.choose_12').css('display', 'block');
            $('.choose_13').css('display', 'block');
        } else if (item.yrp_manage_money == true) {
            $('.manage_money').css('display', 'block');
            $('.choose_11').css('display', 'block');
            $('.choose_12').css('display', 'block');
        } else if (item.yrp_manage_employees_with_salary == true) {
            $('.manage_employees').css('display', 'block');
            $('.choose_14').css('display', 'block');
            $('.choose_15').css('display', 'block');
            $('.choose_16').css('display', 'block');
        } else if (item.yrp_manage_employees == true) {
            $('.manage_employees').css('display', 'block');
            $('.choose_15').css('display', 'block');
            $('.choose_16').css('display', 'block');
        } else if (item.yrp_open_armory_flp == true) {
            $('.armories_flp_nui').css('display', 'block');
        } else if (item.yrp_open_armory_other == true) {
            $('.armories_other').css('display', 'block');
        } else if (item.yrp_custom_c_menu == true) {
            $('.custom_clothes_menu').css('display', 'block');
        } else if (item.yrp_garage_menu == true) {
            $('.choose_7').css('display', 'block');
            $('.choose_8').css('display', 'block');
            $('.garage-menu').css('display', 'block');
        } else if (item.yrp_helicopters_menu == true) {
            $('.choose_18').css('display', 'block');
            $('.choose_19').css('display', 'block');
            $('.helicopters-menu').css('display', 'block');
        } else if (item.yrp_garage_cars == true) {
            $('.container').css('display', 'block');
        } else if (item.yrp_helicopters_list == true) {
            $('.container-helicopters').css('display', 'block');
        } else if (item.yrp_manage_outfits == true) {
            $('.container-manageOutfits').css('display', 'block');
        } else if (item.yrp_create_outfits == true) {
            $('.container-createOutfits').css('display', 'block');
        } else if (item.yrp_put_armory == true) {
            $('.container-putArmory').css('display', 'block');
        } else if (item.yrp_take_armory == true) {
            $('.container-takeArmory').css('display', 'block');
        } else if (item.yrp_shop_armory == true) {
            $('.container-shopArmory').css('display', 'block');
        } else if (item.yrp_manage_salary == true) {
            $('.container-salary').css('display', 'block');
        } else if (item.recruit_employee == true) {
            $('.container-recruit').css('display', 'block');
        } else if (item.employees_list == true) {
            $('.container-employee').css('display', 'block');
        } else if (item.grade_list_promote == true) {
            $('.container-gradeList').css('display', 'block');
        } else if (item.yrp_succes_withdraw == true) {
            $('.manage_money').css('display', 'block');
            $('#money').text('you have successfully withdrawed ' + event.data.money + '$')
            $('.choose_11').css('display', 'none');
            $('.choose_12').css('display', 'none');
            $('.choose_13').css('display', 'none');
            document.getElementsByClassName("popup_money_succes")[0].classList.add("active");
        } else if (item.yrp_succes_deposit == true) {
            $('.manage_money').css('display', 'block');
            $('#dep_money').text('you have successfully deposited ' + event.data.money + '$')
            $('.choose_11').css('display', 'none');
            $('.choose_12').css('display', 'none');
            $('.choose_13').css('display', 'none');
            document.getElementsByClassName("popup_money_dep_succes")[0].classList.add("active");
        } else if (item.yrp_succes_deposit == false) {
            $('.manage_money').css('display', 'block');
            $('.choose_11').css('display', 'none');
            $('.choose_12').css('display', 'none');
            $('.choose_13').css('display', 'none');
            document.getElementsByClassName("popup_money_dep_fail")[0].classList.add("active");
        } else if (item.yrp_succes_wash == true) {
            $('.manage_money').css('display', 'block');
            $('#wash_money').text('you successfully washed ' + event.data.money + '$')
            $('.choose_11').css('display', 'none');
            $('.choose_12').css('display', 'none');
            $('.choose_13').css('display', 'none');
            document.getElementsByClassName("popup_money_wash_succes")[0].classList.add("active");
        } else if (item.yrp_succes_managedSalary == true) {
            $('.manage_employees').css('display', 'block');
            $('#title2').text('you successfully changed salary to ' + event.data.money + '$')
            $('.choose_14').css('display', 'none');
            $('.choose_15').css('display', 'none');
            $('.choose_16').css('display', 'none');
            document.getElementsByClassName("popup_man_sec_succes")[0].classList.add("active");
        } else if (item.yrp_succes_recruit == true) {
            $('.bossmenu').css('display', 'block');
            $('#title2').text('you successfully recruit player')
            $('.choose_9').css('display', 'none');
            $('.choose_10').css('display', 'none');
            document.getElementsByClassName("popup_recruit_succes")[0].classList.add("active");
        } else if (item.yrp_succes_fire == true) {
            $('.bossmenu').css('display', 'block');
            $('#title2').text('you successfully fire player')
            $('.choose_9').css('display', 'none');
            $('.choose_10').css('display', 'none');
            document.getElementsByClassName("popup_recruit_succes")[0].classList.add("active");
        } else if (item.yrp_succes_promote == true) {
            $('.bossmenu').css('display', 'block');
            $('#title2').text('you successfully promote player')
            $('.choose_9').css('display', 'none');
            $('.choose_10').css('display', 'none');
            document.getElementsByClassName("popup_recruit_succes")[0].classList.add("active");
        } else if (item.yrp_succes_wash == false) {
            $('.manage_money').css('display', 'block');
            $('.choose_11').css('display', 'none');
            $('.choose_12').css('display', 'none');
            $('.choose_13').css('display', 'none');
            document.getElementsByClassName("popup_money_wash_fail")[0].classList.add("active");
        } else if (item.yrp_succes_withdraw == false) {
            $('.manage_money').css('display', 'block');
            $('.choose_11').css('display', 'none');
            $('.choose_12').css('display', 'none');
            $('.choose_13').css('display', 'none');
            document.getElementsByClassName("popup_money_fail")[0].classList.add("active");
        } else if (item.yrp_helipad_full == true) {
            $('.helicopters-menu').css('display', 'block');
            document.getElementsByClassName("helipad_full")[0].classList.add("active");
        } else if (item.yrp_hel_spawned == true) {
            $('.helicopters-menu').css('display', 'block');
            document.getElementsByClassName("popup13")[0].classList.add("active");
        } else if (item.yrp_hel_parked == true) {
            $('.helicopters-menu').css('display', 'block');
            document.getElementsByClassName("popup14")[0].classList.add("active");
        } else if (item.yrp_cloakroom == false) {
            $('.cloakroom-menu').css('display', 'none');
            $('.armories_flp_nui').css('display', 'none');
            $('.armories_other').css('display', 'none');
            $('.cloakroom_keys-menu').css('display', 'none');
            $('.bossmenu').css('display', 'none');
            $('.manage_money').css('display', 'none');
            $('.manage_employees').css('display', 'none');
            $('.custom_clothes_menu').css('display', 'none');
            $('.garage-menu').css('display', 'none');
            $('.helicopters-menu').css('display', 'none');
            $('.container').css('display', 'none');
            $('.container-helicopters').css('display', 'none');
            $('.container-salary').css('display', 'none');
            $('.container-recruit').css('display', 'none');
            $('.container-employee').css('display', 'none');
            $('.container-gradeList').css('display', 'none');
            $('.container-manageOutfits').css('display', 'none');
            $('.container-createOutfits').css('display', 'none');
            $('.container-putArmory').css('display', 'none');
            $('.container-takeArmory').css('display', 'none');
            $('.container-shopArmory').css('display', 'none');
            $('.course').css('display', 'none');
            $('.choose_13').css('display', 'none');
            $('.choose_14').css('display', 'none');
            document.getElementById("money_shit").classList.remove("active");
            document.getElementById("money_shit_succes").classList.remove("active");
            document.getElementsByClassName("popup_deposit")[0].classList.remove("active");
            document.getElementsByClassName("popup_wash")[0].classList.remove("active");
            document.getElementsByClassName("popup_money_dep_succes")[0].classList.remove("active");
            document.getElementsByClassName("popup_money_dep_fail")[0].classList.remove("active");
            document.getElementsByClassName("popup_money_wash_succes")[0].classList.remove("active");
            document.getElementsByClassName("popup_money_wash_fail")[0].classList.remove("active");
            document.getElementsByClassName("popup_manage_salary")[0].classList.remove("active");
            document.getElementsByClassName("popup_man_sec_succes")[0].classList.remove("active");
            document.getElementsByClassName("popup_recruit_succes")[0].classList.remove("active");
            document.getElementsByClassName("popup_money_succes")[0].classList.remove("active");
            document.getElementsByClassName("popup_saveOutfits")[0].classList.remove("active");
            document.getElementsByClassName("popup_saveOutfits_2")[0].classList.remove("active");
            document.getElementsByClassName("popup_shitMenu")[0].classList.remove("active");
            document.getElementById("money_shit_fail").classList.remove("active");
            $('.outfitsContainer').remove();
        }

        if (item.model !== undefined) {
            $(".courseContainer").append(`
            <div class="course">
                <div class="preview">
                    <h2>`+item.modelLabel+`</h2>
                    <h6>Tuning : full</h6>
                </div>
                <div class="info">
                    <h2>Police department</h2>
                    <h6>The vehicle is the responsibility of an Associated Police Officer</h6>
                    <button class="btn" onclick="spawnVeh('`+item.model+`', '`+item.livery+`')">Take keys</button>
                </div>
            </div>
            `);
        }

        if (item.model !== undefined) {
            $(".HelicoptersList").append(`
            <div class="course">
                <div class="preview">
                    <h2>`+item.modelLabel+`</h2>
                    <h6>Tuning : full</h6>
                </div>
                <div class="info">
                    <h2>Police department</h2>
                    <h6>The helicopter is the responsibility of an Associated Police Officer</h6>
                    <button class="btn" onclick="spawnHel('`+item.model+`')">Take keys</button>
                </div>
            </div>
            `);
        }

        if (item.grade !== undefined) {
            $(".courseContainerSalary").append(`
            <div class="course">
                <div class="preview">
                    <h2>`+item.grade+`</h2>
                    <h6>Salary : `+item.salary+`$</h6>
                    <h6>Max salary : `+item.maxSalary+`$</h6>
                </div>
                <div class="info">
                    <h2>Police department</h2>
                    <h6>Here you can set the salary for the job of `+item.grade+`</h6>
                    <button class="btn" id="manage_salary" onclick="manageSalary('`+item.gradeName+`')">Manage salary</button>
                </div>
            </div>
            `);
        }

        if (item.name !== undefined) {
            $(".courseContainerRecruit").append(`
            <div class="course">
                <div class="preview">
                    <h2>`+item.name+`</h2>
                    <h6>Job : `+item.job+`</h6>
                </div>
                <div class="info">
                    <h2>Police department</h2>
                    <h6>Click on the recruit button to recruit `+item.name+` to your company </h6>
                    <button class="btn" onclick="recruitPlayer('`+item.identifier+`')">Recruit `+item.name+`</button>
                </div>
            </div>
            `);
        }

        if (item.name !== undefined) {
            $(".courseContainerEmployees").append(`
            <div class="course">
                <div class="preview">
                    <h2>`+item.name+`</h2>
                    <h6>Job : `+item.job+`</h6>
                    <h6>Grade : `+item.grade+`</h6>
                </div>
                <div class="info">
                    <h2>Police department</h2>
                    <h6>Select the option you want to do with the selected player</h6>
                    <button class="btn" onclick="promotePlayer('`+item.identifier+`')">promote</button>
                    <button class="btn" onclick="firePlayer('`+item.identifier+`')">fire</button>
                </div>
            </div>
            `);
        }

        if (item.label !== undefined) {
            $(".courseContainerGradeList").append(`
            <div class="course">
                <div class="preview">
                    <h2>`+item.label+`</h2>
                </div>
                <div class="info">
                    <h2>Police department</h2>
                    <h6>Click the select button to promote or degrade a player </h6>
                    <div class="result" id="result">50 kg</div>
                    <button class="btn" onclick="selectPromote('`+item.identifier+`', '`+item.value+`')">select</button>
                </div>
            </div>
            `);
        }

        if (item.outfitLabel !== undefined) {
            $(".courseContainerManageOutfits").append(`
            <div class="course">
                <div class="preview">
                    <h2>`+item.outfitLabel+`</h2>
                </div>
                <div class="info">
                    <h2>Police department</h2>
                    <h6>Select one of the options</h6>
                    <button class="btn" onclick="dressOutfit('`+item.outfitValue+`')">dress</button>
                    <button class="btn" onclick="deleteOutfit('`+item.outfitValue+`')">delete</button>
                </div>
            </div>
            `);
        }

        if (item.label !== undefined) {
            if (item.type == "outfit") {
                $(".courseContainerCreateOutfits").append(`
                <div class="outfitsContainer">
                    <div class="course">
                        <div class="preview">
                            <h2>`+item.label+`</h2>
                        </div>
                        <div class="info">
                            <h2>Police department</h2>
                            <input class="`+item.name+`" type="range" min="`+item.min+`" value="1" max="`+item.max+`" id="custom-input" onclick="ClothValue('`+item.name+`', '`+item.label+`')">
                            <button class="btn" onclick="setCamera('`+item.name+`', '`+item.cam+`', '`+item.zoom+`')">camera</button>
                        </div>
                    </div>
                </div>
                `);
            }
            if (item.type == "save") {
                $(".courseContainerCreateOutfits").append(`
                <div class="outfitsContainer">
                    <div class="course">
                        <div class="preview">
                            <h2>`+item.label+`</h2>
                        </div>
                        <div class="info">
                            <h2>Police department</h2>
                            <h6>click on the button to save your current outfit</h6>
                            <button class="btn" onclick="saveOutfit('`+item.name+`')">save outfit</button>
                        </div>
                    </div>
                </div>
                `);
            }
        }

        if (item.label !== undefined) {
             if (item.count !== undefined) {
                 $(".coursePutArmory").append(`
                     <div class="course">
                        <div class="preview">
                            <h2>`+item.label+`</h2>
                            <h3>You have `+item.count+`x</h3>
                        </div>
                        <div class="info">
                            <h2>Police department</h2>
                            <h6>Armory</h6>
                            <button class="btn" onclick="putArmory('`+item.name+`', '`+item.label+`', '`+item.count+`', '`+item.type+`')">put</button>
                        </div>
                     </div>
                 `);
             } else {
                 $(".coursePutArmory").append(`
                     <div class="course">
                         <div class="preview">
                             <h2>`+item.label+`</h2>
                         </div>
                         <div class="info">
                             <h2>Police department</h2>
                             <h6>Armory</h6>
                             <button class="btn" onclick="putArmory('`+item.name+`', '`+item.label+`', '`+item.count+`', '`+item.type+`')">put</button>
                         </div>
                     </div>
                 `);
             }
        }

        if (item.label !== undefined) {
              $(".courseShopArmory").append(`
                    <div class="course">
                          <div class="preview">
                              <h2>`+item.label+`</h2>
                              <h3>Price $`+item.price+`</h3>
                          </div>
                          <div class="info">
                               <h2>Police department</h2>
                               <h6>Armory</h6>
                               <button class="btn" onclick="BuyArmory('`+item.name+`', '`+item.label+`', '`+item.price+`', '`+item.type+`')">buy</button>
                          </div>
                    </div>
              `);
        }

                if (item.label !== undefined) {
                      $(".courseGetArmory").append(`
                            <div class="course">
                                  <div class="preview">
                                      <h2>`+item.label+`</h2>
                                      <h3>In armory are `+item.count+`x</h3>
                                  </div>
                                  <div class="info">
                                       <h2>Police department</h2>
                                       <h6>Armory</h6>
                                       <button class="btn" onclick="getArmory('`+item.name+`', '`+item.label+`', '`+item.count+`', '`+item.type+`')">get</button>
                                  </div>
                            </div>
                      `);
                }


	});

    $(".choose_1").click(function() {
        $.post('http://flap_police_job/choose_civilian', JSON.stringify({}));
    });

    $(".choose_2").click(function() {
        $.post('http://flap_police_job/choose_custom', JSON.stringify({}));
    });

    $(".choose_3").click(function() {
        $.post('http://flap_police_job/choose_orange_vest', JSON.stringify({}));
    });

    $(".choose_4").click(function() {
        $.post('http://flap_police_job/choose_bulletproof_vest', JSON.stringify({}));
    });

    $(".choose_5").click(function() {
        $.post('http://flap_police_job/choose_5', JSON.stringify({}));
    });

    $(".choose_6").click(function() {
        $.post('http://flap_police_job/choose_6', JSON.stringify({}));
    });

    $(".choose_7").click(function() {
        $.post('http://flap_police_job/choose_7', JSON.stringify({}));
    });

    $(".choose_8").click(function() {
        $.post('http://flap_police_job/choose_8', JSON.stringify({}));
    });

    $(".choose_9").click(function() {
        $.post('http://flap_police_job/choose_9', JSON.stringify({}));
    });

    $(".choose_10").click(function() {
        $.post('http://flap_police_job/choose_10', JSON.stringify({}));
    });

    $(".choose_11").click(function() {
        document.getElementsByClassName("popup_withdraw")[0].classList.add("active");
    });

    $(".choose_12").click(function() {
        document.getElementsByClassName("popup_deposit")[0].classList.add("active");
    });

    $(".choose_13").click(function() {
        document.getElementsByClassName("popup_wash")[0].classList.add("active");
    });

    $(".choose_14").click(function() {
        $.post('http://flap_police_job/choose_14', JSON.stringify({}));
    });

    $(".choose_15").click(function() {
        $.post('http://flap_police_job/choose_15', JSON.stringify({}));
    });

    $(".choose_16").click(function() {
        $.post('http://flap_police_job/choose_16', JSON.stringify({}));
    });

    $(".choose_17").click(function() {
        $.post('http://flap_police_job/choose_17', JSON.stringify({}));
    });

    $(".choose_20").click(function() {
        $.post('http://flap_police_job/choose_20', JSON.stringify({}));
    });

    $(".choose_18").click(function() {
        $.post('http://flap_police_job/choose_18', JSON.stringify({}));
    });

    $(".choose_19").click(function() {
        $.post('http://flap_police_job/choose_19', JSON.stringify({}));
    });

    $(".choose_21").click(function() {
        $.post('http://flap_police_job/choose_21', JSON.stringify({}));
    });

    $(".choose_22").click(function() {
        $.post('http://flap_police_job/choose_22', JSON.stringify({}));
    });

    $(".choose_23").click(function() {
        $.post('http://flap_police_job/choose_23', JSON.stringify({}));
    });

    $(".choose_24").click(function() {
        $.post('http://flap_police_job/choose_24', JSON.stringify({}));
    });

    $(".choose_25").click(function() {
        $.post('http://flap_police_job/choose_25', JSON.stringify({}));
    });


	$(".dismiss-btn").click(function() {
        $.post('http://flap_police_job/close', JSON.stringify({}));
    });








    
	$("#accept_wit").click(function () {
		let inputValue = $(".inputWithMoney").val()
        if (!inputValue) {
            $.post("http://flap_police_job/Notification", JSON.stringify({
                text: "You can't withdraw 0$"
            }))
            return
        }
        $.post('http://flap_police_job/withdrawMoney', JSON.stringify({
            money: inputValue,
		}));
        return;
    })

    $("#accept_dep").click(function () {
		let inputValue = $(".inputWithDepMoney").val()
        if (!inputValue) {
            $.post("http://flap_police_job/Notification", JSON.stringify({
                text: "You can't deposit 0$"
            }))
            return
        }
        $.post('http://flap_police_job/depositMoney', JSON.stringify({
            money: inputValue,
		}));
        return;
    })

    $("#accept_wash").click(function () {
		let inputValue = $(".inputWithWashMoney").val()
        if (!inputValue) {
            $.post("http://flap_police_job/Notification", JSON.stringify({
                text: "You can't wash 0$"
            }))
            return
        }
        $.post('http://flap_police_job/washMoney', JSON.stringify({
            money: inputValue,
		}));
        return;
    })

    $("#dismiss-popup18-btn").click(function () {
    	let inputValue = $(".inputSetOutName").val()
        if (!inputValue) {
             $.post("http://flap_police_job/Notification", JSON.stringify({
                text: "The outfit wasn't saved, you didn't give a name"
             }))
             return
        }
        $.post('http://flap_police_job/saveNo', JSON.stringify({}));
        $.post('http://flap_police_job/close', JSON.stringify({}));
        $.post('http://flap_police_job/saveOutfit', JSON.stringify({
            name: inputValue,
    	}));
        return;
    })

})

let scale = 0;
const cards = Array.from(document.getElementsByClassName("job"));
const inner = document.querySelector(".inner");

function slideAndScale() {
cards.map((card, i) => {
	card.setAttribute("data-scale", i + scale);
	inner.style.transform = "translateX(" + scale * 8.5 + "em)";
});
}

(function init() {
slideAndScale();
cards.map((card, i) => {
	card.addEventListener("click", () => {
		const id = card.getAttribute("data-scale");
		if (id !== 2) {
			scale -= id - 2;
			slideAndScale();
		}
	}, false);
});
})();

document.getElementById("complete_button1").addEventListener("click",function(){
    document.getElementsByClassName("popup")[0].classList.add("active");
});

document.getElementById("complete_button3").addEventListener("click",function(){
    document.getElementsByClassName("popup")[0].classList.add("active");
});

document.getElementById("complete_button4").addEventListener("click",function(){
    document.getElementsByClassName("popup")[0].classList.add("active");
});

document.getElementById("complete_button5").addEventListener("click",function(){
    document.getElementsByClassName("popup2")[0].classList.add("active");
});

document.getElementById("complete_button6").addEventListener("click",function(){
    document.getElementsByClassName("popup2")[0].classList.add("active");
});

document.getElementById("complete_button8").addEventListener("click",function(){
    document.getElementsByClassName("popup4")[0].classList.add("active");
});

document.getElementById("dismiss-popup-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup")[0].classList.remove("active");
});

document.getElementById("dismiss-popup2-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup2")[0].classList.remove("active");
});

document.getElementById("dismiss-popup3-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup3")[0].classList.remove("active");
});

document.getElementById("dismiss-popup4-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup4")[0].classList.remove("active");
});

document.getElementById("dismiss-popup5-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_withdraw")[0].classList.remove("active");
});

document.getElementById("dismiss-popup6-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_deposit")[0].classList.remove("active");
});

document.getElementById("dismiss-popup7-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_wash")[0].classList.remove("active");
});

document.getElementById("dismiss-popup8-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_manage_salary")[0].classList.remove("active");
});

document.getElementById("dismiss-popup9-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_man_sec_succes")[0].classList.remove("active");
});

document.getElementById("dismiss-popup10-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_recruit_succes")[0].classList.remove("active");
});

document.getElementById("dismiss-popup11-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_money_dep_succes")[0].classList.remove("active");
});

document.getElementById("dismiss-popup12-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_money_dep_fail")[0].classList.remove("active");
});

document.getElementById("dismiss-popup13-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup13")[0].classList.remove("active");
});

document.getElementById("dismiss-popup14-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup14")[0].classList.remove("active");
});

document.getElementById("dismiss-popup15-btn").addEventListener("click",function(){
    document.getElementsByClassName("helipad_full")[0].classList.remove("active");
});

document.getElementById("dismiss-popup16-btn").addEventListener("click",function(){
    $.post('http://flap_police_job/saveNo', JSON.stringify({}));
    document.getElementsByClassName("popup_saveOutfits")[0].classList.remove("active");
    document.getElementsByClassName("popup_saveOutfits_2")[0].classList.add("active");
});

document.getElementById("dismiss-popup17-btn").addEventListener("click",function(){
    $.post('http://flap_police_job/saveNo', JSON.stringify({}));
    $.post('http://flap_police_job/close', JSON.stringify({}));
    document.getElementsByClassName("popup_saveOutfits")[0].classList.remove("active");
});

function spawnVeh(model, livery) {
    $.post('http://flap_police_job/spawnVeh', JSON.stringify({ model: model, livery: livery}));
    document.getElementsByClassName("popup3")[0].classList.add("active");
    $('.choose_7').css('display', 'none');
    $('.choose_8').css('display', 'none');
    $('.container').css('display', 'none');
}

function spawnHel(model) {
    $.post('http://flap_police_job/spawnHel', JSON.stringify({ model: model}));
}

function recruitPlayer(identifier) {
    $.post('http://flap_police_job/recruitPlayer', JSON.stringify({
        identifier: identifier
    }));
}

function firePlayer(identifier) {
    $.post('http://flap_police_job/firePlayer', JSON.stringify({
        identifier: identifier
    }));
}

function promotePlayer(identifier) {
    $.post('http://flap_police_job/promotePlayer', JSON.stringify({
        identifier: identifier
    }));
}

function selectPromote(identifier, grade) {
    $.post('http://flap_police_job/selectPromote', JSON.stringify({
        identifier: identifier,
        grade: grade
    }));
}

function deleteOutfit(outfit) {
    $.post('http://flap_police_job/deleteOutfit', JSON.stringify({
        outfit: outfit
    }));
}

function dressOutfit(outfit) {
    $.post('http://flap_police_job/dressOutfit', JSON.stringify({
        outfit: outfit
    }));
}

function manageSalary(grade) {
    document.getElementsByClassName("popup_manage_salary")[0].classList.add("active");


    $(".accept-btn").append(`
    <button class= "test" id="accept_man_salary" onclick="manageSalary2('`+grade+`')">
        confirm
    </button>
    `);
}

function manageSalary2(grade) {
    let inputValue = $(".inputManageSalary").val()
    $.post('http://flap_police_job/openManageGrades', JSON.stringify({
        grade: grade,
        money: inputValue
    }));

    $('.test').remove();
}

function ClothValue(name, label) {
    let barValue = $("." + name).val()
    let result = Math.round(barValue * 10) / 10;


    $.post('http://flap_police_job/setCloth', JSON.stringify({
        result: result,
        name: name
    }));

}

function setCamera(name, cam, zoom) {

    $.post('http://flap_police_job/setCam', JSON.stringify({
        name: name,
        cam: cam,
        zoom: zoom
    }));

}

function saveOutfit(name) {

     $('.container-createOutfits').css('display', 'none');
     document.getElementsByClassName("popup_saveOutfits")[0].classList.add("active");

}

function putArmory(name, label, count, type) {

	document.getElementsByClassName("popup_shitMenu")[0].classList.add("active");
	$('.neco').remove();
	$(".popup_shitMenu").append(`
	    <div class="neco">
           <div class="icon">
                <i class="fas fa-store-alt"></i>
            </div>
            <div class="titleArmory">
            </div>
            <div class="descriptionArmory" id="test">
            </div>

            <input placeholder="amount" type="number" id="info-button" name="quantity" class="inputPutItemCount" min="0" max="100" step="1">

           <div class="buttons">
                <div class="dismiss-btn">
                    <button id="dismiss-popup-btn" onclick="putItem('`+name+`', '`+type+`')">
                         confirm
                    </button>
                    <button id="dismiss-popupPutArmory-btn" onclick="closeShitMenus()">
                         close
                    </button>
                 </div>
           </div>
		</div>
	`);
		$('.titleArmory').text(label)
    	$('.descriptionArmory').text("You have " + count + "x")

}

function getArmory(name, label, count, type) {

	document.getElementsByClassName("popup_shitMenu")[0].classList.add("active");
	$('.neco').remove();
	$(".popup_shitMenu").append(`
	    <div class="neco">
           <div class="icon">
                <i class="fas fa-store-alt"></i>
            </div>
            <div class="titleArmory">
            </div>
            <div class="descriptionArmory" id="test">
            </div>

            <input placeholder="amount" type="number" id="info-button" name="quantity" class="inputGetItemCount" min="0" max="100" step="1">

           <div class="buttons">
                <div class="dismiss-btn">
                    <button id="dismiss-popup-btn" onclick="getItem('`+name+`', '`+type+`')">
                         confirm
                    </button>
                    <button id="dismiss-popupPutArmory-btn" onclick="closeShitMenus()">
                         close
                    </button>
                 </div>
           </div>
		</div>
	`);
		$('.titleArmory').text(label)
    	$('.descriptionArmory').text("In armory are " + count + "x")

}

function BuyArmory(name, label, price, type) {

	document.getElementsByClassName("popup_shitMenu")[0].classList.add("active");
	$('.neco').remove();
	$(".popup_shitMenu").append(`
	    <div class="neco">
           <div class="icon">
                <i class="fas fa-store-alt"></i>
            </div>
            <div class="titleArmory">
            </div>
            <div class="descriptionArmory" id="test">
            </div>

            <input placeholder="amount" type="number" id="info-button" name="quantity" class="inputBuyItemCount" min="0" max="100" step="1">

           <div class="buttons">
                <div class="dismiss-btn">
                    <button id="dismiss-popup-btn" onclick="buyItem('`+name+`', '`+price+`', '`+type+`')">
                         confirm
                    </button>
                    <button id="dismiss-popupPutArmory-btn" onclick="closeShitMenus()">
                         close
                    </button>
                 </div>
           </div>
		</div>
	`);
		$('.titleArmory').text(label)
    	$('.descriptionArmory').text("Price $" + price + " per count")

}

function buyItem(item, price, type) {
	let inputValue = $(".inputBuyItemCount").val()
	$.post('http://flap_police_job/close', JSON.stringify({}));
	if (!inputValue) {
    	$.post("http://yrp_shops/Notification", JSON.stringify({
    		text: "you can not buy 0 item"
    	}))
    	return
    }
    $.post('http://flap_police_job/buyItems', JSON.stringify({
    	item: item,
    	price: price,
    	count: inputValue,
    	type: type
    }));
}

function putItem(item, type) {
	let inputValue = $(".inputPutItemCount").val()
	$.post('http://flap_police_job/close', JSON.stringify({}));
	if (!inputValue) {
    	$.post("http://yrp_shops/Notification", JSON.stringify({
    		text: "you can not put 0 item"
    	}))
    	return
    }
    $.post('http://flap_police_job/putItems', JSON.stringify({
    	item: item,
    	count: inputValue,
    	type: type
    }));
}

function getItem(item, type) {
	let inputValue = $(".inputGetItemCount").val()
	$.post('http://flap_police_job/close', JSON.stringify({}));
	if (!inputValue) {
    	$.post("http://yrp_shops/Notification", JSON.stringify({
    		text: "you can not get 0 item"
    	}))
    	return
    }
    $.post('http://flap_police_job/getItems', JSON.stringify({
    	item: item,
    	count: inputValue,
    	type: type
    }));
}

function closeShitMenus() {
     document.getElementsByClassName("popup_shitMenu")[0].classList.remove("active");
}