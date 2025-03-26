// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

// Rendre bootstrap disponible globalement
window.bootstrap = bootstrap

// Réinitialiser les composants Bootstrap après chaque navigation Turbo
document.addEventListener("turbo:load", () => {
  // Réinitialiser les dropdowns
  const dropdownElementList = document.querySelectorAll('.dropdown-toggle')
  const dropdownList = [...dropdownElementList].map(dropdownToggleEl => new bootstrap.Dropdown(dropdownToggleEl))

  // Réinitialiser les alertes fermables
  const alertList = document.querySelectorAll('.alert')
  alertList.forEach((alert) => new bootstrap.Alert(alert))
})

// Nettoyer les composants Bootstrap avant la navigation
document.addEventListener("turbo:before-cache", () => {
  // Fermer tous les dropdowns ouverts
  const dropdowns = document.querySelectorAll('.dropdown-menu.show')
  dropdowns.forEach(dropdown => {
    const toggle = document.querySelector(`[data-bs-toggle="dropdown"][aria-expanded="true"]`)
    if (toggle) {
      const instance = bootstrap.Dropdown.getInstance(toggle)
      if (instance) {
        instance.hide()
      }
    }
  })

  // Fermer toutes les alertes
  const alerts = document.querySelectorAll('.alert')
  alerts.forEach(alert => {
    const instance = bootstrap.Alert.getInstance(alert)
    if (instance) {
      instance.close()
    }
  })
})
