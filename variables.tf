variable "cloudfront_response_headers_policies" {
  description = <<EOT
Map of cloudfront_response_headers_policies, attributes below
Required:
    - name
Optional:
    - comment
    - cors_config (block):
        - access_control_allow_credentials (required)
        - access_control_allow_headers (required, block):
            - items (optional)
        - access_control_allow_methods (required, block):
            - items (optional)
        - access_control_allow_origins (required, block):
            - items (optional)
        - access_control_expose_headers (optional, block):
            - items (optional)
        - access_control_max_age_sec (optional)
        - origin_override (required)
    - custom_headers_config (block):
        - items (optional, block):
            - header (required)
            - override (required)
            - value (required)
    - remove_headers_config (block):
        - items (optional, block):
            - header (required)
    - security_headers_config (block):
        - content_security_policy (optional, block):
            - content_security_policy (required)
            - override (required)
        - content_type_options (optional, block):
            - override (required)
        - frame_options (optional, block):
            - frame_option (required)
            - override (required)
        - referrer_policy (optional, block):
            - override (required)
            - referrer_policy (required)
        - strict_transport_security (optional, block):
            - access_control_max_age_sec (required)
            - include_subdomains (optional)
            - override (required)
            - preload (optional)
        - xss_protection (optional, block):
            - mode_block (optional)
            - override (required)
            - protection (required)
            - report_uri (optional)
    - server_timing_headers_config (block):
        - enabled (required)
        - sampling_rate (required)
EOT

  type = map(object({
    name    = string
    comment = optional(string)
    cors_config = optional(object({
      access_control_allow_credentials = bool
      access_control_allow_headers = object({
        items = optional(set(string))
      })
      access_control_allow_methods = object({
        items = optional(set(string))
      })
      access_control_allow_origins = object({
        items = optional(set(string))
      })
      access_control_expose_headers = optional(object({
        items = optional(set(string))
      }))
      access_control_max_age_sec = optional(number)
      origin_override            = bool
    }))
    custom_headers_config = optional(object({
      items = optional(list(object({
        header   = string
        override = bool
        value    = string
      })))
    }))
    remove_headers_config = optional(object({
      items = optional(list(object({
        header = string
      })))
    }))
    security_headers_config = optional(object({
      content_security_policy = optional(object({
        content_security_policy = string
        override                = bool
      }))
      content_type_options = optional(object({
        override = bool
      }))
      frame_options = optional(object({
        frame_option = string
        override     = bool
      }))
      referrer_policy = optional(object({
        override        = bool
        referrer_policy = string
      }))
      strict_transport_security = optional(object({
        access_control_max_age_sec = number
        include_subdomains         = optional(bool)
        override                   = bool
        preload                    = optional(bool)
      }))
      xss_protection = optional(object({
        mode_block = optional(bool)
        override   = bool
        protection = bool
        report_uri = optional(string)
      }))
    }))
    server_timing_headers_config = optional(object({
      enabled       = bool
      sampling_rate = number
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.cloudfront_response_headers_policies : (
        v.server_timing_headers_config == null || (v.server_timing_headers_config.sampling_rate >= 0.0 && v.server_timing_headers_config.sampling_rate <= 100.0)
      )
    ])
    error_message = "must be between 0.0 and 100.0"
  }
  # Note: 2 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

