module Proj
  # Tracks whether a PROJ context is still alive. Shared between a Context and
  # the finalizers of objects that depend on it (PjObject, Session). Because
  # Ruby's GC finalizer ordering is non-deterministic during shutdown, a
  # dependent's finalizer may run after its context has already been destroyed.
  # Calling proj_destroy() in that situation segfaults (PROJ 9.8+). This object
  # lets dependents check before calling into PROJ.
  class LifeSpan
    def initialize
      @alive = true
    end

    def alive?
      @alive
    end

    def ended!
      @alive = false
    end
  end
end
