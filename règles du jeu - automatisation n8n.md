# Règles du Jeu - Automatisation n8n

## 📋 Vue d'ensemble du projet

Ce document définit les règles, lignes directrices et méthodologies pour la création, correction et amélioration d'automatisations sur n8n avec l'assistance IA.

### Objectifs du projet
- **Créer** des workflows n8n innovants et adaptés aux besoins spécifiques
- **Corriger** les automatisations existantes présentant des dysfonctionnements
- **Améliorer** les workflows pour optimiser performances, fiabilité et maintenabilité
- **Garantir** la qualité maximale grâce à l'utilisation combinée des outils spécialisés

---

## 🛠️ Outils à disposition

### 1. n8n MCP Server
**Serveur MCP (Model Context Protocol)** - Bridge entre n8n et l'IA

#### Données disponibles
- **1,084 nodes n8n** : 537 core + 547 community (301 verified)
- **99% de couverture** des propriétés des nodes avec schémas détaillés
- **63.6% de couverture** des opérations disponibles
- **87% de documentation** depuis docs officiels n8n (incluant nodes IA)
- **265 variantes d'outils IA** détectées avec documentation complète
- **2,646 exemples** de configurations extraites de templates populaires
- **2,709 templates de workflows** avec 100% de métadonnées
- **Nodes communautaires** : recherche intégrée avec filtre `source`

#### Capacités principales
- Accès aux workflows existants via API n8n
- Analyse et validation de configurations
- Création, modification, déploiement de workflows
- Récupération des logs d'exécution
- Gestion des credentials et variables d'environnement
- Recherche sémantique dans les nodes et templates
- Validation multi-niveaux (minimal/full/runtime/strict)

### 2. n8n Skills
**Ensemble de 7 compétences spécialisées** qui enseignent à l'IA comment construire des workflows n8n de qualité production

#### Les 7 Skills

**1. n8n Expression Syntax**
- Syntaxe correcte des expressions n8n ({{}} patterns)
- Variables core : `$json`, `$node`, `$now`, `$env`
- **GOTCHA CRITIQUE** : Les données webhook sont sous `$json.body`
- Catalogue des erreurs communes avec corrections
- Quand NE PAS utiliser d'expressions (Code nodes !)

**2. n8n MCP Tools Expert** (PRIORITÉ MAXIMALE)
- Guide de sélection des outils MCP (quel outil pour quelle tâche)
- Formats de nodeType : `nodes-base.*` vs `n8n-nodes-base.*`
- Profils de validation : minimal/runtime/ai-friendly/strict
- Paramètres intelligents : `branch="true"` pour nodes IF
- Système d'auto-sanitization expliqué

**3. n8n Workflow Patterns**
- 5 patterns architecturaux éprouvés :
  - Webhook processing
  - HTTP API integration
  - Database operations
  - AI workflows
  - Scheduled tasks
- Checklist de création de workflow
- 2,653+ exemples réels de templates n8n
- Best practices de connexion

**4. n8n Validation Expert**
- Interprétation des erreurs de validation
- Workflow de correction des erreurs
- Catalogue d'erreurs réelles avec solutions
- Comportement d'auto-sanitization
- Guide des faux positifs
- Sélection de profils selon les étapes

**5. n8n Node Configuration**
- Configuration guidée par opérations
- Règles de dépendances entre propriétés
  - Exemple : `sendBody` → `contentType`
- Exigences spécifiques par opération
- Types de connexions IA (8 types pour AI Agent workflows)
- Patterns de configuration courants

**6. n8n Code JavaScript**
- Patterns d'accès aux données : `$input.all()`, `$input.first()`, `$input.item`
- **GOTCHA CRITIQUE** : Webhook data sous `$json.body`
- Format de retour correct : `[{json: {...}}]`
- Fonctions built-in : `$helpers.httpRequest()`, `DateTime`, `$jmespath()`
- Top 5 des patterns d'erreur (couvrant 62%+ des échecs)
- 10 patterns testés en production

**7. n8n Code Python**
- **IMPORTANT** : Utiliser JavaScript pour 95% des cas
- Accès aux données Python : `_input`, `_json`, `_node`
- **Limitation critique** : Pas de bibliothèques externes (requests, pandas, numpy)
- Référence bibliothèque standard : json, datetime, re, etc.
- Workarounds pour bibliothèques manquantes
- Patterns Python courants pour n8n

### 3. Combinaison synergique
**IMPÉRATIF** : Utiliser systématiquement les deux outils en complémentarité pour :
- Analyser le contexte réel via MCP Server
- Appliquer les meilleures pratiques via n8n Skills
- Proposer des solutions optimales et contextualisées

---

## 🔧 Outils MCP n8n disponibles

### Outils Core (7 outils essentiels)

#### 1. `tools_documentation`
Obtenir la documentation pour n'importe quel outil MCP
- **COMMENCER ICI** pour comprendre un outil
- Documentation détaillée avec exemples

#### 2. `search_nodes`
Recherche full-text dans tous les nodes
```javascript
// Rechercher nodes avec exemples de configuration
search_nodes({
  query: 'send email gmail',
  includeExamples: true  // Retourne top 2 configs par node
})

// Rechercher nodes communautaires uniquement
search_nodes({
  query: 'scraping',
  source: 'community'  // Options: all, core, community, verified
})

// Nodes communautaires vérifiés
search_nodes({
  query: 'pdf',
  source: 'verified'
})
```

#### 3. `get_node`
Outil unifié d'information sur les nodes (v2.26.0)
```javascript
// Mode Info (par défaut)
get_node({
  nodeType: 'n8n-nodes-base.httpRequest',
  detail: 'standard',      // minimal | standard | full
  includeExamples: true    // Exemples réels de templates
})

// Mode Documentation (markdown lisible)
get_node({
  nodeType: 'n8n-nodes-base.slack',
  mode: 'docs'
})

// Recherche de propriétés spécifiques
get_node({
  nodeType: 'n8n-nodes-base.httpRequest',
  mode: 'search_properties',
  propertyQuery: 'authentication'
})

// Historique des versions
get_node({
  nodeType: 'n8n-nodes-base.httpRequest',
  mode: 'versions'  // ou 'compare' | 'breaking' | 'migrations'
})
```

#### 4. `validate_node`
Validation unifiée de nodes (v2.26.0)
```javascript
// Validation rapide (champs requis uniquement)
validate_node({
  nodeType: 'n8n-nodes-base.slack',
  config: { resource: 'message', operation: 'send' },
  mode: 'minimal'  // <100ms
})

// Validation complète avec profils
validate_node({
  nodeType: 'n8n-nodes-base.httpRequest',
  config: { method: 'POST', url: '...' },
  mode: 'full',
  profile: 'runtime'  // minimal | runtime | ai-friendly | strict
})
```

#### 5. `validate_workflow`
Validation complète de workflow incluant AI Agent
- Validation des connexions
- Validation des expressions n8n
- Détection des language models manquants
- Validation des connexions d'outils IA
- Vérification des contraintes de streaming
- Checks mémoire et parsers de sortie

#### 6. `search_templates`
Recherche unifiée de templates (v2.26.0)
```javascript
// Recherche par mots-clés (défaut)
search_templates({
  searchMode: 'keyword',
  query: 'slack notification'
})

// Par nodes spécifiques
search_templates({
  searchMode: 'by_nodes',
  nodeTypes: ['n8n-nodes-base.slack', 'n8n-nodes-base.webhook']
})

// Par tâche (templates curés)
search_templates({
  searchMode: 'by_task',
  task: 'webhook_processing'  // ou slack_integration, etc.
})

// Par métadonnées
search_templates({
  searchMode: 'by_metadata',
  complexity: 'simple',
  requiredService: 'openai',
  targetAudience: 'marketers',
  maxSetupMinutes: 30
})
```

#### 7. `get_template`
Récupérer JSON complet de workflow
```javascript
get_template(templateId, {
  mode: 'full'  // nodes_only | structure | full
})
```

### Outils de Gestion n8n (13 outils - Requiert configuration API)

**Prérequis** : Variables `N8N_API_URL` et `N8N_API_KEY` configurées

#### Gestion de Workflows

**`n8n_create_workflow`**
- Créer nouveaux workflows avec nodes et connexions

**`n8n_get_workflow`** (v2.26.0)
```javascript
// Modes disponibles
n8n_get_workflow({
  id: 'wf-123',
  mode: 'full'  // full | details | structure | minimal
})
```

**`n8n_update_full_workflow`**
- Mise à jour complète (remplacement total)

**`n8n_update_partial_workflow`**
- Mise à jour via opérations diff (efficient en tokens)
```javascript
n8n_update_partial_workflow({
  id: 'wf-123',
  operations: [
    {type: 'updateNode', nodeId: 'slack-1', changes: {...}},
    {type: 'addConnection', source: 'node-1', target: 'node-2', 
     sourcePort: 'main', targetPort: 'main'},
    {type: 'cleanStaleConnections'}
  ]
})
```

**`n8n_delete_workflow`**
- Suppression permanente de workflows

**`n8n_list_workflows`**
- Lister workflows avec filtrage et pagination

**`n8n_validate_workflow`**
- Valider workflows dans n8n par ID

**`n8n_autofix_workflow`**
- Correction automatique d'erreurs communes

**`n8n_workflow_versions`**
- Gérer historique de versions et rollback

**`n8n_deploy_template`**
- Déployer templates depuis n8n.io directement vers votre instance avec auto-fix

#### Gestion des Exécutions

**`n8n_test_workflow`**
- Tester/déclencher exécution de workflow
- Auto-détection du type de trigger (webhook, form, chat)
- Support données custom, headers, méthodes HTTP pour webhooks
- Support message et sessionId pour chat triggers

**`n8n_executions`** (v2.26.0)
```javascript
// Lister exécutions
n8n_executions({
  action: 'list',
  workflowId: 'wf-123',
  status: 'error'  // success | error | waiting
})

// Obtenir détails
n8n_executions({
  action: 'get',
  executionId: 'exec-456'
})

// Supprimer
n8n_executions({
  action: 'delete',
  executionId: 'exec-456'
})
```

#### Outils Système

**`n8n_health_check`**
- Vérifier connectivité API n8n et fonctionnalités

### Nodes n8n les plus populaires

1. **n8n-nodes-base.code** - JavaScript/Python scripting
2. **n8n-nodes-base.httpRequest** - Appels API HTTP
3. **n8n-nodes-base.webhook** - Triggers événementiels
4. **n8n-nodes-base.set** - Transformation de données
5. **n8n-nodes-base.if** - Routing conditionnel
6. **n8n-nodes-base.manualTrigger** - Exécution manuelle
7. **n8n-nodes-base.respondToWebhook** - Réponses webhook
8. **n8n-nodes-base.scheduleTrigger** - Triggers temporels
9. **@n8n/n8n-nodes-langchain.agent** - Agents IA
10. **n8n-nodes-base.googleSheets** - Intégration spreadsheet
11. **n8n-nodes-base.merge** - Fusion de données
12. **n8n-nodes-base.switch** - Routing multi-branches
13. **n8n-nodes-base.telegram** - Intégration bot Telegram
14. **@n8n/n8n-nodes-langchain.lmChatOpenAi** - Modèles chat OpenAI
15. **n8n-nodes-base.splitInBatches** - Traitement par batch

**Note** : Nodes LangChain utilisent le préfixe `@n8n/n8n-nodes-langchain.`, nodes core utilisent `n8n-nodes-base.`

---

## 🎯 Méthodologie de travail

### Phase 1 : Analyse
1. **Comprendre le besoin**
   - Écouter attentivement la demande
   - Identifier les objectifs métier
   - Clarifier les contraintes et dépendances

2. **Explorer l'existant** (via MCP Server)
   - Lister les workflows pertinents
   - Analyser l'architecture actuelle
   - Identifier les patterns utilisés
   - Vérifier les credentials disponibles

3. **Diagnostiquer les problèmes** (si correction)
   - Examiner les logs d'erreur
   - Identifier les points de défaillance
   - Analyser les performances
   - Repérer les configurations obsolètes

### Phase 2 : Conception
1. **Proposer une architecture**
   - Dessiner le flux logique
   - Sélectionner les nodes appropriés
   - Planifier la gestion des erreurs
   - Prévoir la scalabilité

2. **Appliquer les best practices** (via n8n Skills)
   - Utiliser les patterns recommandés
   - Implémenter les techniques d'optimisation
   - Respecter les conventions de nommage
   - Structurer pour la maintenabilité

3. **Valider la conception**
   - Vérifier la cohérence
   - Anticiper les cas limites
   - Évaluer la robustesse
   - Estimer les performances

### Phase 3 : Implémentation
1. **Créer/Modifier le workflow**
   - Construire node par node
   - Configurer précisément chaque élément
   - Implémenter la logique métier
   - Ajouter la gestion d'erreurs

2. **Tester rigoureusement**
   - Tester les chemins nominaux
   - Tester les cas d'erreur
   - Vérifier les données de sortie
   - Valider les performances

3. **Documenter**
   - Ajouter des notes explicatives
   - Documenter les choix techniques
   - Expliquer les configurations complexes
   - Fournir des exemples d'utilisation

### Phase 4 : Livraison
1. **Présenter la solution**
   - Expliquer clairement les changements
   - Mettre en avant les améliorations
   - Documenter les points d'attention
   - Fournir des recommandations

2. **Former si nécessaire**
   - Expliquer le fonctionnement
   - Montrer comment modifier
   - Indiquer les bonnes pratiques
   - Partager les ressources utiles

---

## ✅ Standards de qualité

### Architecture
- ✓ Workflows modulaires et réutilisables
- ✓ Séparation des responsabilités
- ✓ Gestion robuste des erreurs
- ✓ Retry logic appropriée
- ✓ Timeouts configurés
- ✓ Logging approprié

### Performance
- ✓ Optimisation des requêtes API
- ✓ Utilisation du batching quand pertinent
- ✓ Mise en cache si applicable
- ✓ Limitation du nombre d'itérations
- ✓ Gestion efficace de la mémoire

### Sécurité
- ✓ Credentials stockés de manière sécurisée
- ✓ Validation des inputs
- ✓ Sanitization des données sensibles
- ✓ Gestion appropriée des permissions
- ✓ Pas de secrets en dur dans le code

### Maintenabilité
- ✓ Nommage explicite et cohérent
- ✓ Documentation inline suffisante
- ✓ Structure claire et lisible
- ✓ Versions et changelog
- ✓ Tests et validation

---

## 🚨 Gestion des erreurs

### Principes
1. **Anticiper** : Prévoir les erreurs potentielles
2. **Capturer** : Utiliser des error workflows ou nodes
3. **Informer** : Logger avec contexte suffisant
4. **Récupérer** : Implémenter retry et fallback
5. **Alerter** : Notifier en cas d'échec critique

### Implémentation
- Utiliser les Error Triggers pour capturer les erreurs
- Configurer des retry strategies adaptées
- Implémenter des fallbacks métier
- Logger dans un système centralisé si possible
- Envoyer des notifications pertinentes (email, Slack, etc.)

---

## 📊 Types de workflows courants

### 1. Workflows d'intégration
- Synchronisation entre applications
- Transfert de données
- Transformations de format
- Enrichissement de données

### 2. Workflows d'automatisation métier
- Processus de validation
- Workflows d'approbation
- Gestion de tâches récurrentes
- Notifications automatiques

### 3. Workflows de traitement de données
- ETL (Extract, Transform, Load)
- Agrégation et reporting
- Nettoyage de données
- Analyses et calculs

### 4. Workflows d'orchestration
- Coordination de microservices
- Gestion d'événements
- Pipelines complexes
- Workflows conditionnels

---

## 🔄 Process de correction

### Diagnostic
1. Collecter les informations d'erreur
2. Reproduire le problème si possible
3. Identifier la cause racine
4. Évaluer l'impact

### Correction
1. Proposer une solution
2. Expliquer le problème et la correction
3. Implémenter la correction
4. Tester exhaustivement
5. Déployer avec précaution

### Prévention
1. Identifier pourquoi l'erreur s'est produite
2. Améliorer la robustesse
3. Ajouter des tests/validations
4. Documenter pour éviter la récurrence

---

## 🎨 Amélioration continue

### Critères d'amélioration
- **Performance** : Réduire le temps d'exécution
- **Fiabilité** : Augmenter le taux de succès
- **Maintenabilité** : Simplifier la structure
- **Scalabilité** : Permettre plus de volume
- **UX** : Améliorer la clarté et la lisibilité

### Opportunités d'amélioration
- Refactoring de workflows complexes
- Migration vers des nodes plus performants
- Ajout de fonctionnalités manquantes
- Optimisation des performances
- Amélioration de la gestion d'erreurs

---

## 📝 Conventions de nommage

### Workflows
Format : `[Catégorie] Nom descriptif - Version`
Exemple : `[CRM] Sync Contacts Hubspot to Airtable - v2.1`

### Nodes
Format : `Action - Contexte (optionnel)`
Exemples :
- `Get Contact Data`
- `Transform - Format Phone`
- `Send - Slack Notification`
- `Error Handler - Retry Logic`

### Variables
Format : `camelCase` ou `snake_case` (cohérence dans tout le workflow)
Exemples : `contactEmail`, `customer_id`, `isValid`

---

## 🔐 Accès et permissions

### Dashboard n8n
- Accès complet au dashboard
- Visualisation de tous les workflows
- Consultation des logs et métriques
- Gestion des credentials (lecture)

### Projets
- Accès à tous les projets
- Modification des workflows
- Création de nouveaux workflows
- Export/Import de workflows

### Limites
- Pas de suppression de workflows sans validation
- Pas de modification de credentials sensibles sans accord
- Notification avant changements majeurs
- Backup recommandé avant modifications importantes

---

## 🎓 Apprentissage continu

### Ressources
- Documentation officielle n8n
- Communauté n8n
- Forums et discussions
- Templates de la communauté

### Évolution
- Rester à jour sur les nouvelles features n8n
- Explorer les nouveaux nodes
- Tester les patterns émergents
- Partager les découvertes

---

## 📞 Communication

### Principes
- **Clarté** : Explications précises et compréhensibles
- **Transparence** : Communiquer les limites et contraintes
- **Proactivité** : Proposer des améliorations
- **Pédagogie** : Former et transmettre les connaissances

### Format de livraison
1. **Résumé** : Vue d'ensemble des changements
2. **Détails** : Explication technique
3. **Tests** : Résultats et validations
4. **Documentation** : Guide d'utilisation
5. **Recommandations** : Prochaines étapes suggérées

---

## ✨ Engagement qualité

En tant qu'assistant IA pour ce projet, je m'engage à :

1. ✓ Utiliser **systématiquement** n8n MCP Server ET n8n Skills
2. ✓ Analyser en profondeur avant de proposer
3. ✓ Suivre rigoureusement la méthodologie
4. ✓ Respecter tous les standards de qualité
5. ✓ Documenter exhaustivement
6. ✓ Tester avant de livrer
7. ✓ Communiquer clairement
8. ✓ Apprendre et m'améliorer continuellement

**Objectif ultime** : Fournir des workflows n8n de **qualité professionnelle maximale**, robustes, performants et maintenables.

---

## 🚀 Prêt à commencer

Ce document constitue la base de notre collaboration. Pour chaque demande :

1. 🔍 J'analyserai via MCP Server
2. 📚 J'appliquerai les n8n Skills
3. 🎯 Je suivrai la méthodologie
4. ✅ Je garantirai la qualité
5. 📝 Je documenterai complètement

**Prêt à créer, corriger et améliorer vos automatisations n8n !**
