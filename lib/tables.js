import { $ } from 'meteor/jquery';
import Tabular from 'meteor/aldeed:tabular';
import { Template } from 'meteor/templating';
// import moment from 'moment';
import { Meteor } from 'meteor/meteor';
import dataTableButtons from 'datatables.net-buttons-se';
import columnVisibilityButton from 'datatables.net-buttons/js/buttons.colVis.js';

if (Meteor.isClient){
//   // import 'https://cdn.datatables.net/1.10.16/css/dataTables.semanticui.min.css';
//   // import dataTablesBootstrap from 'datatables.net-bs';
//   // import html5ExportButtons from 'datatables.net-buttons/js/buttons.html5.js';
//   // import flashExportButtons from 'datatables.net-buttons/js/buttons.flash.js';
//   // import printButton from 'datatables.net-buttons/js/buttons.print.js';
//   // import "https://cdn.datatables.net/1.10.16/js/dataTables.semanticui.min.js";

//   // dataTablesBootstrap(window, $);
  dataTableButtons(window, $);
  columnVisibilityButton(window, $);
//   // html5ExportButtons(window, $);
//   // flashExportButtons(window, $);
//   // printButton(window, $);
}


new Tabular.Table({
  name: "Reports",
  collection: Docs,
  lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv', 'colvis'],
  columns: [
    {data: "report_id", title: "Id"},
    {data: "report_title", title: "Title"},
    {data: "report_type", title: "Type"},
    {data: "report_subtitle", title: "Subtitle"},
    // {
    //   data: "lastCheckedOut",
    //   title: "Last Checkout",
    //   render: function (val, type, doc) {
    //     if (val instanceof Date) {
    //       return moment(val).calendar();
    //     } else {
    //       return "Never";
    //     }
    //   }
    // },
    // {data: "summary", title: "Summary"},
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});


new Tabular.Table({
  name: "Incidents",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 25,
  lengthChange: false,
  // buttons: [ 'copy', 'excel', 'pdf', 'colvis' ],
  order: [[ 2, 'desc' ]],
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'csv'],
  columns: [
    // {data: "incident_number", title: "Ticket Number"},
    {
      data: "incident_type", 
      title: "Type",
      tmpl: Meteor.isClient && Template.incident_type_label 
    },
    // {data: "when", title: "Logged"},
    {
      data: "timestamp",
      title: "Logged",
      render: function (timestamp, type, doc) {
        return doc.when();
      }
    },     
    {
      data: "incident_details",
      title: "Details",
      render: function (incident_details, type, doc) {
        if (incident_details) {
          // var snippet = incident_details.substr(0, 100) + "..."
          var snippet = incident_details.substr(0, 100)
          return snippet
        } else {
          return "";
        }
      }
    },
    { data: "customer_jpid", title: "Customer JPID" },
    // { data: "customer_name", title: "Customer Name" },
    { data: "current_level", title: "Level"},
    { 
      data: "assigned_to",
      title: "Assigned To",
      tmpl: Meteor.isClient && Template.associated_users 
    },
    { 
      data: "", 
      title: "Actions Taken",
      tmpl: Meteor.isClient && Template.small_doc_history 
    },
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});

new Tabular.Table({
  name: "Fields",
  collection: Docs,
  lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv', 'colvis'],
  columns: [
    {data: "field_slug", title: "Slug"},
    {data: "field_display_name", title: "Display Name"},
    {data: "field_display_type", title: "Display Type"},
  ]
});
new Tabular.Table({
  name: "Special_services",
  collection: Docs,
  lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv', 'colvis'],
  columns: [
    {data: "ev.ID", title: "JPID"},
    {data: "ev.CUSTOMER", title: "Customer"},
    {data: "ev.CUST_OPS_MANAGER", title: "Operations Manager"},
    {data: "ev.FRANCHISEE", title: "Franchisee"},
    {data: "ev.SERV_TYPE", title: "Service Type"},
    {data: "ev.EXTRA_SERV_DESC", title: "Extra Service Description"},
    {data: "ev.DATE_CREATED", title: "Date Created"},
    {data: "ev.EXTRA_PRICE", title: "Extra Price"}
  ]
});

new Tabular.Table({
  name: "Users",
  collection: Meteor.users,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "username", title: "Username"},
    {data: "profile.first_name", title: "First Name"},
    {data: "profile.last_name", title: "Last Type"},
    {data: "ev.JOB_TITLE", title: "Title"},
    {data: "ev.WORK_TELEPHONE", title: "Work Tel"},
    {data: "emails[0].address", title: "Email"},
    {data: "profile.office_name", title: "Office Name"},
    { tmpl: Meteor.isClient && Template.view_user_button }

  ]
});


new Tabular.Table({
  name: "Jpids",
  collection: Docs,
  lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv', 'colvis'],
  columns: [
    {data: "jpid", title: "JP Id"},
    {data: "ev.CUSTOMER", title: "Customer"},
    {data: "ev.FRANCHISEE", title: "Franchisee"},
    {data: "ev.ASSIGNED_TO", title: "Assigned To"},
    {data: "ev.MASTER_LICENSEE", title: "Master"},
    {data: "ev.ACCOUNT_STATUS", title: "Status"},
    {data: "ev.AREA", title: "Area"},
    { tmpl: Meteor.isClient && Template.view_button }

  ]
});



new Tabular.Table({
  name: "Areas",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "number", title: "Number"},
    {data: "title", title: "Name"},
  ]
});



new Tabular.Table({
  name: "Ev_roles",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "slug", title: "Slug"},
    {data: "title", title: "Name"},
  ]
});

new Tabular.Table({
  name: "Meta",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "area", title: "Field Name"},
    {data: "jpid", title: "MetaData Name"},
    {data: "value", title: "MetaData Title"},
    // { tmpl: Meteor.isClient && Template.view_button }
  ]
});


new Tabular.Table({
  name: "Franchisees",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "jpid", title: "JP ID"},
    {data: "franchisee", title: "Name"},
    {data: "ev.FRANCH_EMAIL", title: "Email"},
    {data: "ev.FRANCH_NAME", title: "Short Name"},
    {data: "ev.TELE_CELL", title: "Cell"},
    {data: "ev.MASTER_LICENSEE", title: "Office"},
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});

new Tabular.Table({
  name: "Offices",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "office_name", title: "Name"},
    // {data: "display_name", title: "Display Name"},
    {data: "telephone", title: "Cell"},
    {data: "address", title: "Address"},
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});


new Tabular.Table({
  name: "Related_franchisees",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 25,
  // paging: false,
  // searching: false,
  lengthChange: false,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "jpid", title: "JP ID"},
    {data: "franchisee", title: "Franchisee"},
    {data: "ev.FRANCH_NAME", title: "Short Name"},
    {data: "ev.TELE_CELL", title: "Cell"},
    {data: "franchisee_email", title: "Email"},
    {data: "ev.MASTER_LICENSEE", title: "Office"},
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});

new Tabular.Table({
  name: "History",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // paging: false,
  searching: false,
  lengthChange: false,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "ev.AREA", title: "Area"},
    {data: "ev.PROJECT", title: "Project"},
    {data: "ev.TIMESTAMP", title: "Timestamp"},
    {data: "ev.LAST_CHANGE_USER", title: "Last Change User"},
    {data: "franchisee_email", title: "Email"},
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});


new Tabular.Table({
  name: "Search_history",
  collection: Docs,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // paging: false,
  searching: false,
  lengthChange: false,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "ev.ID", title: "ID"},
    {data: "ev.AREA", title: "Area"},
    {data: "ev.TIMESTAMP", title: "Timestamp"},
    {data: "ev.LAST_CHANGE_USER", title: "Last Change User"},
    {data: "ev.PROJECT", title: "Project"},
    {data: "ev.FRANCHISEE", title: "Franchisee"},
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});




new Tabular.Table({
  name: "Customers",
  collection: Docs,
  lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "cust_name", title: "Customer Name"},
    {data: "jpid", title: "JP ID"},
    {data: "franchisee", title: "Franchisee"},
    {data: "master_licensee", title: "Master Licensee"},
    {data: "customer_contact_person", title: "Customer Contact Person"},
    {data: "customer_contact_email", title: "Customer Contact Email"},
    {data: "ev.ADDR_STATE", title: "State"},
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});

new Tabular.Table({
  name: "Related_customers",
  collection: Docs,
  paging: true,
  searching: false,
  lengthChange: false,
  // lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
  pageLength: 10,
  // buttonContainer: '.col-sm-6:eq(0)',
  // buttons: ['copy', 'excel', 'pdf', 'csv'],
  columns: [
    {data: "jpid", title: "JP ID"},
    {data: "franchisee", title: "Franchisee"},
    {data: "cust_name", title: "Customer Name"},
    {data: "master_licensee", title: "Master Licensee"},
    {data: "customer_contact_person", title: "Contact Person"},
    {data: "customer_contact_email", title: "Contact Email"},
    {data: "ev.ADDR_STATE", title: "State"},
    { tmpl: Meteor.isClient && Template.view_button }
  ]
});