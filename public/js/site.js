jQuery.fn.sort = function() { 
    return this.pushStack( jQuery.makeArray( [].sort.apply( this, arguments ) ) ); 
}; 

function renderGitHub(json) {
    var list = $('#github ul');
    var repos = $(json.repositories).sort(function(a,b) {
        return a.name.localeCompare(b.name);
    });

    $.each(repos, function(i, rep) {
        var item = $('<li>');
        var link = $('<a>');
        link.attr('href', rep.url);
        link.attr('target', '_new');
        var fork = rep.fork ? ' (fork)' : '';
        link.text(rep.name + fork);
        item.append(link);
        list.append(item);
        item.append('<p>' + rep.description + '</p>');
    });
}