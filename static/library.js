$(main);

$('.toggle').click(function(){
    target = $(this).attr('target');
    $('#'+target).toggle();
});

function main()
{
    $('#books').hide();
    $('#readers').hide();
    $('#branches').hide();
}