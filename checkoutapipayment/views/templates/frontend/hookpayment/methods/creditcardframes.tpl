<ul class="payment_methods">
{if $isGuest == 0 && $saveCard== 'yes'}
    {if !empty($cardLists)}
        {foreach name=outer item=card_number from=$cardLists}
          {foreach key=key item=item from=$card_number}
            {if $key == 'card_number'}
                {assign var="card_number" value="{$item}"}
            {/if}

            {if $key == 'card_type'}
                {assign var="card_type" value="{$item}"}
            {/if}

            {if $key == 'entity_id'}
                {assign var="entity_id" value="{$item}"}
            {/if}

            {/foreach}

            <li>  
                <label>
                <input id="checkoutapipayment-saved-card" class="checkoutapipayment-saved-card" type="radio" name="checkoutapipayment-saved-card" value="{$entity_id}"/>xxxx-{$card_number}-{$card_type}</label>   
            </li>
        {/foreach}
             <li>
                <label>
                <input id="checkoutapipayment-new-card" class= "checkoutapipayment-new-card" type="radio" name="checkoutapipayment-new-card"  value="new_card"/>{l s='Use New card' mod='checkoutapipayment'}</label>
            </li>

        {else}
            <li>
                <label>
                <input id="checkoutapipayment-new-card" class= "checkoutapipayment-new-card" type="radio" name="checkoutapipayment-new-card"  value="new_card"/>{l s='Use New card' mod='checkoutapipayment'}</label>
            </li>
    {/if}
{/if}

{if $saveCard == 'no' and $altPayment == 'yes'}
        <label>
        <input id="checkoutapipayment-new-card" class= "checkoutapipayment-new-card" type="radio" name="checkoutapipayment-new-card"  value="new_card"/>{l s='Use New card' mod='checkoutapipayment'}</label>
{/if}

</ul>

<div class="checkout-non-pci-new-card-row">
    <script async src="{$hppUrl}"></script>
    <script type="text/javascript">
        window.CKOConfig = {
            publicKey: '{$publicKey}',
            theme: '{$theme}',
            
            cardTokenised: function(event) {
                if (document.getElementById('cko-card-token').value.length === 0) {
                    document.getElementById('cko-card-token').value = event.data.cardToken;

                    if(jQuery('#uniform-checkoutapipayment-new-card span').hasClass('checked')){
                        document.getElementById('new-card').value = 1;
                    } 

                    document.getElementById('checkoutapipayment_form').submit();
                }
            },
            frameActivated: function(){
                    document.getElementById('cko-iframe-id').style.position = "relative";
                    $('.cko-md-overlay').remove();
            },
            cardValidationChanged: function (event) { console.log('cardValidationChanged');
                document.getElementsByClassName('button btn btn-default button-medium')[1].disabled = !Frames.isCardValid();
            },
            ready: function(){
                // setTimeout(function(){
                //     var submitButton = document.getElementsByClassName('button btn btn-default button-medium')[1];
                //     submitButton.disabled = true;
                   
                //     submitButton.addEventListener("click", function () {
                //         if (Frames.isCardValid()) Frames.submitCard();
                //     });
                // }, 2000);
                // var submitButton = document.getElementsByClassName('button btn btn-default button-medium')[1];
                // submitButton.disabled = true;
               
                // submitButton.addEventListener("click", function () {
                //     if (Frames.isCardValid()) Frames.submitCard();
                // });
            }
        };
    </script>
    <form id="checkoutapipayment_form">
        <input type="hidden" name="cko-card-token" id="cko-card-token" value="">
        <input type="hidden" name='new-card' id="new-card" value="">
        <input type="hidden" id="cko-lp-lpName" name="cko-lp-lpName" value=""/>
        <input type="hidden" id="cko-lp-issuerId" name="cko-lp-issuerId" value=""/>
    </form>
</div>

{if $saveCard == 'yes' }
    <div class="save-card-checkbox"  style="display:none">
        <div class="out">
            <input type="checkbox" name="save-card-checkbox" id="save-card-checkbox" value="1"></input>
            <label for="save-card-checkbox" style="padding-left: 20px;">{l s='Save card for future payment' mod='checkoutapipayment'}</label>
        </div>
    </div>
{/if}


<!-- Alternative payments -->
{if $altPayment == 'yes'}
    <div class="altPayment">
        <br>
        <label for="alternative-payment">{l s='Alternative Payment' mod='checkoutapipayment'}</label>
        <br>
        <div style="display: flex;">
            {foreach key=key item=item from=$localPayment}
                {if $key == 'name'}
                    {assign var="name" value="{$item['name']}"}
                {/if}
            <div class="apmSelected">
                <label class="apmLabel">
                    <img id="imgTe" src="https://cdn.checkout.com/sandbox/img/lp_logos/{$item['name']|lower}.png" style="width: 50px;"/>
                    <input id="alt-payment" class="alt-payment" type="radio" name="alt-payment" value="{$item['name']}"/>
                </label>   
            </div>
            {/foreach} 
        </div>
        {literal}
                <link rel="stylesheet" href="../modules/checkoutapipayment/skin/css/checkout_frames" type="text/css" media="screen" />
        {/literal}

        <div id="ckoModal" class="ckoModal" >
              <!-- Modal content -->
            <div class="cko-modal-content" style="width: 30%;">
                <span class="close" onclick="modal.style.display = 'none';">x</span>
                <p><h1><span  id="lpName"></span ></h1></p>
                <br>
                <div id="idealInfo" style="display: none;">
                    <label for="issuerId" >Issuer ID
                    <select id="issuer" >
                        {if isset($idealPaymentInfo)}
                            {foreach key=key item=item from=$idealPaymentInfo}
                                <option value="{$item->value}" />{$item->key}
                            {/foreach}
                        {/if}
                    </select>
                </label>
                </div>
                <div id="boletoInfo">
                    <div class="boleto-row"><label for="boletoDate" >Date of birth</label>
                    <input type="date" id="boletoDate" name="boletoDate" /></div>
                    <div class="boleto-row"></div>
                    <div class="boleto-row"><label for="cpf" >CPF</label>
                    <input type="text" id="cpf" name="cpf" /></div>
                    <div class="boleto-row"></div>
                    <div class="boleto-row"><label for="custName" ">Customer Name</label>
                    <input type="text" id="custName" name="custName" required /></div>
                </div>
                <div id="qiwiInfo" style="display: none;">
                    <label for="walletId">Wallet Id
                        <input type="text" id="walletId" name="walletId" placeholder="+44 phone number" />
                    </label>
                </div>

                <button type="button" id="mybtn" style="margin-top: 50px;">Continue</button>
            </div>
            
        </div>

        {literal}
            <script type="application/javascript">
                var modal = document.getElementById('ckoModal');

                //When the user clicks anywhere outside of the modal, close it
                window.onclick = function(event) {
                   if (event.target == modal) {
                       modal.style.display = "none";
                   }
                }
            </script>
        {/literal}

    </div>
{/if}

</div>

{literal} 
    <script type="application/javascript"> 
        checkoutHideNewNoPciCard();
        function checkoutHideNewNoPciCard() {
            jQuery('#uniform-checkoutapipayment-new-card span').removeClass('checked');
            jQuery('.checkout-non-pci-new-card-row').hide();
            jQuery('#uniform-alt-payment span').removeClass('checked');
            jQuery('.apmSelected').removeClass('apmLab');
        }

        function checkoutShowNewNoPciCard() {
            jQuery('#uniform-checkoutapipayment-saved-card span').removeClass('checked');
            jQuery('.checkout-non-pci-new-card-row').show();
            jQuery('.save-card-checkbox').show();
            jQuery('#uniform-alt-payment span').removeClass('checked');
            jQuery('.apmSelected').removeClass('apmLab');
        } 

        jQuery('.checkoutapipayment-saved-card').on("click", function() {
            jQuery('.save-card-checkbox').hide();
            checkoutHideNewNoPciCard();
            var submitButton = document.getElementsByClassName('button btn btn-default button-medium')[1];
            submitButton.disabled = false;

            submitButton.onclick = function(){
                document.getElementById('checkoutapipayment_form').submit();
            };

        });

        jQuery('.checkoutapipayment-new-card').on("click", function() {          
            checkoutShowNewNoPciCard();
            var submitButton = document.getElementsByClassName('button btn btn-default button-medium')[1];
            submitButton.disabled = false;  

            submitButton.onclick = function(){
                    if (Frames.isCardValid()) Frames.submitCard();
            };
        });

        jQuery('.alt-payment').on("click", function() { console.log('clicked');
            jQuery('.apmSelected').removeClass('apmLab');
            jQuery(this).closest('.apmSelected').addClass('apmLab');
            jQuery('#uniform-checkoutapipayment-new-card span').removeClass('checked');
            jQuery('.checkout-non-pci-new-card-row').hide();
            jQuery('.save-card-checkbox').hide();
            jQuery('#uniform-checkoutapipayment-saved-card span').removeClass('checked');

            var submitButton = document.getElementsByClassName('button btn btn-default button-medium')[1];
            submitButton.disabled = false;

            submitButton.onclick = function(){


                    // if(jQuery('.alt-payment').length > 0 && jQuery('.alt-payment').is(':checked') ){

                        if(jQuery('.alt-payment:checked').val() == 'IDeal' || jQuery('.alt-payment:checked').val() == 'Qiwi' ||
                            jQuery('.alt-payment:checked').val() == 'Boleto'){
                            // Open modal
                            var modal = document.getElementById('ckoModal');
                            modal.style.display = "block";

                            var selectedLpName = jQuery('.alt-payment:checked').val();
                            jQuery("#lpName").text("Pay with "+selectedLpName);

                            if(selectedLpName == 'IDeal'){
                                jQuery('#idealInfo').show();
                                jQuery('#boletoInfo').hide();
                                jQuery('#qiwiInfo').hide();
                            } else if(selectedLpName == 'Boleto'){
                                jQuery('#idealInfo').hide();
                                jQuery('#boletoInfo').show();
                                jQuery('#qiwiInfo').hide();
                            } else if(selectedLpName == 'Qiwi'){
                                jQuery('#qiwiInfo').show();
                                jQuery('#boletoInfo').hide();
                                jQuery('#idealInfo').hide();
                            }
                        } else {
                            var selectedLpName = jQuery('.alt-payment:checked').val();
                            document.getElementById('cko-lp-lpName').value = selectedLpName;
                            document.getElementById('checkoutapipayment_form').submit();
                        }

                        jQuery('#mybtn').on('click', function(e) {
                            if(selectedLpName == 'IDeal'){
                                var e = document.getElementById("issuer");
                                var value = e.options[e.selectedIndex].value;
                                var text = e.options[e.selectedIndex].text;

                                document.getElementById('cko-lp-issuerId').value = value;
                            } else if(selectedLpName == 'Boleto'){
                                if(document.getElementById('boletoDate').value == ""){
                                    alert('Please enter correct date');
                                    return false;
                                }

                                if(document.getElementById('cpf').value == ""){
                                    alert('Please enter your CPF');
                                    return false;
                                }

                                if(document.getElementById('custName').value == ""){
                                    alert('Please enter your customer name');
                                    return false;
                                }

                            } else if(selectedLpName == 'Qiwi'){
                                if(document.getElementById('walletId').value == ""){
                                    alert('Please enter your Wallet Id');
                                    return false;
                                }
                            }

                            modal.style.display = "none";

                            document.getElementById('cko-lp-lpName').value = selectedLpName;
                            document.getElementById('checkoutapipayment_form').submit();
                        });
                    // }
                //document.getElementById('checkoutapipayment_form').submit();
            };
            
        });

    </script>
{/literal}

{if $isGuest == 1 }
    <script type="text/javascript">
        jQuery('.checkout-non-pci-new-card-row').show();
    </script>
{/if}

{if $isGuest eq 0 and $saveCard eq 'no' }
        <script type="text/javascript"> 
            jQuery('.checkout-non-pci-new-card-row').show();
            jQuery('.save-card-checkbox').hide();
        </script>

    {elseif $isGuest eq 0 and $saveCard eq 'yes'}
        {if empty($cardLists)}
            <script type="text/javascript"> 
                jQuery('.checkout-non-pci-new-card-row').show();
                jQuery('.save-card-checkbox').show();
            </script>
            {/if}
{/if}

{literal}
    <script type="text/javascript">
        setTimeout(function(){
            var submitButton = document.getElementsByClassName('button btn btn-default button-medium')[1];
            submitButton.disabled = true;

            submitButton.addEventListener("click", function () {
                if (Frames.isCardValid()) Frames.submitCard();
            });
        }, 2000);
    </script>
{/literal}
