(function() {
  window.App = window.App || {}
  window.App.adminSidebar = {
    saveSidebarScrollPosition: function() {
      var sidebar = this.page().find('.sidebar');
      var sidebarScrollTop = sidebar.scrollTop();
      localStorage.setItem('admin-SidebarScrollTop', sidebarScrollTop);
    },

    restoreSidebarScrollPosition: function() {
      var sidebar = this.page().find('.sidebar');
      var sidebarScrollTop = localStorage.getItem('admin-SidebarScrollTop');
      sidebar.scrollTop(sidebarScrollTop);
    },

    clearSidebarScrollPosition: function() {
      localStorage.setItem('admin-SidebarScrollTop', 0);
    },

    page: function() {
      return $('.admin-page');
    }
  };
}).call(this);

$(document).on('turbolinks:load', function() {
  var component = $('.admin-page');
  if (component.length > 0) {
    App.adminSidebar.restoreSidebarScrollPosition();
  }
});

$(document).on('turbolinks:before-render', function() {
  var component = $('.admin-page');
  if (component.length > 0) {
    App.adminSidebar.saveSidebarScrollPosition();
  } else {
    App.adminSidebar.clearSidebarScrollPosition();
  }
});
